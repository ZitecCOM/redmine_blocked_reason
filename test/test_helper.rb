# Code coverage setup
require 'simplecov'
SimpleCov.start do
  add_group 'Hooks', 'lib/redmine_blocked_reason/hooks'
  add_group 'Patches', 'lib/redmine_blocked_reason/patches'
  add_filter '/test/'
  add_filter 'init.rb'
  root File.expand_path(File.dirname(__FILE__) + '/../')
  coverage_dir 'tmp/coverage'
end

# Load the Redmine helper
require File.expand_path File.dirname(__FILE__) << '/../../../test/test_helper'

# Including FactoryGirl methods in test classes
base = ActiveSupport::TestCase
methods = FactoryGirl::Syntax::Methods
base.send :include, methods unless base.included_modules.include? methods
