class BlockedReason < ActiveRecord::Base
  belongs_to :blocked_reason_type
  belongs_to :issue
  delegate :name, to: :blocked_reason_type, prefix: :type
  delegate :css_class, to: :blocked_reason_type, prefix: :type

  acts_as_event datetime: :created_at,
    description: proc {|my| my.comment },
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
          project_id: my.issue.project_id }
      },
    type: 'blocked-reason'

  def author
    user
  end
end
