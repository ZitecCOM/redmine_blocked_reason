require File.expand_path '../../test_helper', __FILE__

class QueryPatchTest < ActiveSupport::TestCase
  test 'Query is patched' do
    patch = RedmineBlockedReason::Patches::QueryPatch
    assert_includes Query.included_modules, patch
    %i(available_filters_without_blocked_reasons
      available_filters_with_blocked_reasons
      sql_for_field_with_blocked_reasons).each do |method|
        assert_includes Query.instance_methods, method
      end
  end
end
