require 'spec_helper'

describe Query, type: :model do
  it 'is patched with RedmineBlockedReason::Patches::QueryPatch' do
    patch = RedmineBlockedReason::Patches::QueryPatch
    expect(Query.included_modules).to include(patch)
  end
end
