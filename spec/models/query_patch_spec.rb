require 'spec_helper'

describe Query, type: :model do
  it 'is patched with RedmineBlockedReason::Patches::IssueQueryPatch' do
    patch = RedmineBlockedReason::Patches::IssueQueryPatch
    expect(Query.included_modules).to include(patch)
  end
end
