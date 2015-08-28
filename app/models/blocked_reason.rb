class BlockedReason < ActiveRecord::Base
  unloadable
  belongs_to :blocked_reason_type
  belongs_to :issue
  has_one :project, through: :issue
  delegate :name, to: :blocked_reason_type, prefix: :type
  delegate :css_class, to: :blocked_reason_type, prefix: :type

  acts_as_event datetime: :created_at, description: proc {|my| my.comment },
    title: proc {|my|
        tracker_name = my.issue.tracker.name
        issue_id = my.issue.id
        blocked_title = if my.unblocker?
            I18n.t('unblocked_reason')
          else
            I18n.t('blocked_reason') +  ' - ' + my.type_name
          end
        subject = my.issue.subject
         "#{ tracker_name } ##{ issue_id } (#{ blocked_title }): #{ subject }"
      },
    url: proc {|my|
        { controller: 'issues', action: 'show', id: my.issue.id,
          project_id: my.project.id }
      },
    type: 'blocked-reason'

  acts_as_activity_provider scope: includes([:project, :issue]),
    author_key: :user_id, permission: :view_blocked_reasons_activity,
    type: 'blocked_reason', timestamp: :created_at

  def self.find_or_create_for(issue)
    BlockedReason.where(issue_id: issue.id, active: true).first ||
      BlockedReason.new
  end

  def author
    User.find user_id
  end
end
