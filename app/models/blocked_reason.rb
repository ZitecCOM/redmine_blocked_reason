class BlockedReason < ActiveRecord::Base
  unloadable
  belongs_to :blocked_reason_type
  belongs_to :issue
  delegate :name, to: :blocked_reason_type, prefix: :type

  acts_as_event :datetime => :updated_at,
    :description => :name,
    :title => Proc.new { |o| "##{o.id} - #{o.name}" },
    :url => Proc.new { |o| { :controller => 'issues', :action => 'show', :id => o.issue.id,
      :project_id => o.project }
    }

  acts_as_activity_provider find_options: { include: :project },
    type: 'blocked_reason',
    timestamp: :updated_at
end
