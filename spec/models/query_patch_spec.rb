require 'spec_helper'

describe IssueQuery, type: :model do
  it 'is patched with RedmineBlockedReason::Patches::IssueQueryPatch' do
    patch = RedmineBlockedReason::Patches::IssueQueryPatch
    expect(IssueQuery.included_modules).to include(patch)
  end
end
