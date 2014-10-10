require_dependency 'projects_helper'

module BlockedReasonProjectsHelperPatch
  def self.included(base)
    base.send(:include, ProjectsHelperMethodsBlockedReason)
    base.class_eval do
      unloadable
      alias_method_chain :project_settings_tabs, :blocked_reason
    end
  end
end

module ProjectsHelperMethodsBlockedReason
  # Append tab for blocked reason to project settings tabs.
  def project_settings_tabs_with_blocked_reason
    tabs = project_settings_tabs_without_blocked_reason
    action = {name: 'block_reasons',
      controller: 'blocked_reason_settings',
      action: :index,
      partial: 'blocked_reason_settings/index',
      label: 'helpers.label.block_settings'}
    tabs << action #if User.current.allowed_to?(action, @project)
    tabs
  end
end

unless ProjectsHelper.included_modules.include? BlockedReasonProjectsHelperPatch
  ProjectsHelper.send(:include, BlockedReasonProjectsHelperPatch)
end
