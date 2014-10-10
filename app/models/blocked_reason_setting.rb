class BlockedReasonSetting < ActiveRecord::Base
  include Redmine::SafeAttributes
  unloadable
  belongs_to :project

  validates_uniqueness_of :project_id
  validates_presence_of :project_id

  safe_attributes 'enabled'

  def self.find_or_create(project_id)
    setting = BlockedReasonSetting.find(:first, conditions: ['project_id = ?', project_id])
    unless setting
      setting = BlockedReasonSetting.new
      setting.project_id = project_id
      setting.save!
    end
    return setting
  end
end
