class BlockedReason < ActiveRecord::Base
  unloadable
  belongs_to :blocked_reason_type
  belongs_to :issue
  has_one :project, through: :issue
  delegate :name, to: :blocked_reason_type, prefix: :type
  delegate :css_class, to: :blocked_reason_type, prefix: :type

  acts_as_event :datetime => :created_at,
    :description => Proc.new {|o| o.comment},
    :title => Proc.new { |o| "#{o.issue.tracker.name} ##{o.issue.id} (#{o.unblocker ? I18n.t('unblocked_reason') : I18n.t('blocked_reason') +  ' - ' + o.type_name}): #{o.issue.subject}" },
    :url => Proc.new { |o| { :controller => 'issues', :action => 'show', :id => o.issue.id,
      :project_id => o.project }
    },
    type: 'blocked-reason'

  acts_as_activity_provider scope: includes([:project, :issue]),
    author_key: :user_id,
    permission: :view_blocked_reasons_activity,
    type: 'blocked_reason',
    timestamp: :created_at

  def self.find_or_create_for(issue)
    BlockedReason.where(issue_id: issue.id, active: true).first || BlockedReason.new
  end

  def author
    User.find user_id
  end
end
