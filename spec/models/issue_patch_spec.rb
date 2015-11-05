require 'spec_helper'

describe Issue, type: :model do
  it 'is patched with RedmineBlockedReason::Patches::IssuePatch' do
    patch = RedmineBlockedReason::Patches::IssuePatch
    expect(Issue.included_modules).to include(patch)
  end
end
