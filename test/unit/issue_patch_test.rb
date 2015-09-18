require File.expand_path '../../test_helper', __FILE__

class IssuePatchTest < ActiveSupport::TestCase
  test 'Issue is patched' do
    patch = RedmineBlockedReason::Patches::IssuePatch
    assert_includes Issue.included_modules, patch
    %i(keep_old_status_id_value unblock_issue).each do |method|
        assert_includes Issue.instance_methods, method
      end
  end
end
