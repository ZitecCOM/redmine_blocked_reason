class BlockedReasonType < ActiveRecord::Base
  has_many :blocked_reason
  attr_accessible :name, :css_class

  def self.for_sidebar(project: nil)
    reasons = joins(blocked_reason: :issue)
      .includes(:blocked_reason)
      .select([:id, :name, :css_class, 'COUNT(blocked_reasons.id) AS count'])
      .group(:id, :name, :css_class)

    if project
      reasons = reasons.where(issues: {project_id: project.id})
    end

    reasons
  end
end
