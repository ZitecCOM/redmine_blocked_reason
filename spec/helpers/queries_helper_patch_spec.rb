require 'spec_helper'

describe QueriesHelper, type: :helper do
  it 'is patched with RedmineBlockedReason::Patches::QueriesHelperPatch' do
    patch = RedmineBlockedReason::Patches::QueriesHelperPatch
    expect(QueriesHelper.included_modules).to include(patch)
  end
end
