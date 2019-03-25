class BlockedReasonType < ActiveRecord::Base
  include Redmine::SafeAttributes

  has_many :blocked_reason
  safe_attributes :name, :css_class

  def self.for_sidebar(project: nil)
    issues_scope = Issue.visible.open.select('issues.id').joins(:project)
    issues_scope = issues_scope.where(:project => project.id) if project

    reasons = BlockedReason.joins(:blocked_reason_type)
      .select(["#{self.table_name}.id", "#{BlockedReasonType.table_name}.name", "#{BlockedReasonType.table_name}.css_class", 'COUNT(blocked_reasons.id) AS count'])
      .where("#{BlockedReason.table_name}.issue_id" => issues_scope)
      .group("#{BlockedReasonType.table_name}.id", "#{BlockedReasonType.table_name}.name", "#{BlockedReasonType.table_name}.css_class")

    reasons
  end
end
