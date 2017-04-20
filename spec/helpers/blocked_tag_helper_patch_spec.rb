require 'spec_helper'

describe IssuesController, type: :controller do
  it 'is patched with IssuesBlockedReasonHelper' do
    patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
    expect(IssuesController.included_modules).to include(patch)
  end
end

describe CalendarsController, type: :controller do
  it 'is patched with RedmineBlockedReason::Patches::BlockedTagHelperPatch' do
    patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
    expect(CalendarsController.included_modules).to include(patch)
  end
end

describe GanttsController, type: :controller do
  it 'is patched with RedmineBlockedReason::Patches::BlockedTagHelperPatch' do
    patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
    expect(GanttsController.included_modules).to include(patch)
  end
end

describe MyController, type: :controller do
  it 'is patched with RedmineBlockedReason::Patches::BlockedTagHelperPatch' do
    patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
    expect(MyController.included_modules).to include(patch)
  end
end
