require 'spec_helper'

describe IssuesHelper, type: :helper do
  it 'is patched with RedmineBlockedReason::Patches::BlockedTagHelperPatch' do
    patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
    expect(IssuesHelper.included_modules).to include(patch)
  end
end

describe MyHelper, type: :helper do
  it 'is patched with RedmineBlockedReason::Patches::BlockedTagHelperPatch' do
    patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
    expect(MyHelper.included_modules).to include(patch)
  end
end

describe QueriesHelper, type: :helper do
  it 'is patched with RedmineBlockedReason::Patches::BlockedTagHelperPatch' do
    patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
    expect(QueriesHelper.included_modules).to include(patch)
  end
end
