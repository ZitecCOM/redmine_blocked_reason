require 'redmine'

# Patches to the Redmine core.
ActionDispatch::Callbacks.to_prepare do
  Dir[File.dirname(__FILE__) + '/lib/redmine_blocked_reason/patches/*_patch.rb'].each {|file|
    require_dependency file
  }

  Dir[File.dirname(__FILE__) + '/lib/redmine_blocked_reason/hooks/*_hook.rb'].each {|file|
    require_dependency file
  }
end

Redmine::Plugin.register :redmine_blocked_reason do
  name 'Redmine Blocked Reason plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  requires_redmine version: '2.5.0'
  # load order does not seem to work, see redmine/config/additional_enviornment.rb
  # requires_redmine_plugin :redmine_new_issue_view, version: '0.0.1'

  settings :default => {
    :default_enabled => false,
  }, :partial => 'blocked_reason_global_settings/index'

  project_module :blocked_reason do
    permission :edit_blocked_reasons, {

    }
    permission :block_issue, {

    }
    permission :view_blocked_reasons_activity_stream, {

    }
  end
end

Redmine::Activity.register :blocked_reason
