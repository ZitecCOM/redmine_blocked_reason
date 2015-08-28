ActionDispatch::Callbacks.to_prepare do
  paths = '/lib/redmine_blocked_reason/{patches/*_patch,hooks/*_hook}.rb'
  Dir.glob(File.dirname(__FILE__) + paths).each do |file|
    require_dependency file
  end
end

Redmine::Plugin.register :redmine_blocked_reason do
  name 'Redmine Blocked Reason plugin'
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
