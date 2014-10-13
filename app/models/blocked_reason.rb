class BlockedReason < ActiveRecord::Base
  unloadable
  belongs_to :blocked_reason_type
  belongs_to :issue
  has_one :project, through: :issue
  delegate :name, to: :blocked_reason_type, prefix: :type

  acts_as_event :datetime => :updated_at,
    :description => 'Am aparut si eu',
    :title => Proc.new { |o| "Am aparut" },
    :url => Proc.new { |o| { :controller => 'issues', :action => 'show', :id => o.issue.id,
      :project_id => o.project }
    },
    type: 'blocked-reason'

  acts_as_activity_provider find_options: {include: :project},
    author_key: :user_id,
    permission: :view_blocked_reasons_activity_stream,
    type: 'blocked_reason',
    timestamp: :updated_at
end
