ActionDispatch::Callbacks.to_prepare do
  paths = '/lib/redmine_blocked_reason/{patches/*_patch,hooks/*_hook}.rb'
  Dir.glob(File.dirname(__FILE__) << paths).each do |file|
    require_dependency file
  end
end

Redmine::Plugin.register :redmine_blocked_reason do
  name 'Blocked Reason'
  author 'Zitec'
  description 'Add Blocked Reasons to Issues'
  version '1.0.1'
  url 'https://github.com/sdwolf/redmine_blocked_reason'
  author_url 'http://zitec.ro'

  settings default: { default_enabled: false },
    partial: 'blocked_reason_types/plugin'
  project_module :blocked_reason do
    permission :edit_blocked_reasons, { blocked_reason: [:update],
      require: :member }
    permission :block_issue, { blocked_reason: [:create], require: :member }
    permission :view_blocked_reasons_activity, {}
  end
end

Redmine::Activity.register :blocked_reason

Rails.application.config.after_initialize do
  test_dependencies = { redmine_testing_gems: '1.1.1' }
  restrict_tracker = Redmine::Plugin.find :redmine_restrict_tracker
  check_dependencies = proc do |plugin, version|
    begin
      restrict_tracker.requires_redmine_plugin plugin, version
    rescue Redmine::PluginNotFound => error
      raise Redmine::PluginNotFound,
        "Restrict Tracker depends on plugin: " \
          "#{ plugin } version: #{ version }"
    end
  end
  test_dependencies.each &check_dependencies if Rails.env.test?
end
