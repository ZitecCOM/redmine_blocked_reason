require File.expand_path '../../test_helper', __FILE__

class QueriesHelperPatchTest < ActiveSupport::TestCase
  test 'QueriesHelper is patched' do
    patch = RedmineBlockedReason::Patches::QueriesHelperPatch
    assert_includes QueriesHelper.included_modules, patch
    %i(column_value_without_blocked_reason_tag
      column_value_with_blocked_reason_tag).each do |method|
        assert_includes QueriesHelper.instance_methods, method
      end
  end
end
