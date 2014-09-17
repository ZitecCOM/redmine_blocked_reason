require "redmine"

# Patches to the Redmine core.
ActionDispatch::Callbacks.to_prepare do
  Dir[File.dirname(__FILE__) + '/lib/redmine_blocked_reason/patches/*_patch.rb'].each {|file| 
    require file 
  }

  Dir[File.dirname(__FILE__) + '/lib/redmine_blocked_reason/hooks/*_hook.rb'].each {|file| 
    require file 
  }

end



Redmine::Plugin.register :redmine_blocked_reason do
  name 'Redmine Blocked Reason plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
