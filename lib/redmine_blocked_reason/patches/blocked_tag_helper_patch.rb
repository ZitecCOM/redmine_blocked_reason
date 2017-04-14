module RedmineBlockedReason
  module Patches
    module BlockedTagHelperPatch
      def self.included(base)
        base.class_eval do
          helper IssuesBlockedReasonHelper
        end
      end
    end
  end
end

bases = [
  IssuesController,
  CalendarsController,
  GanttsController,
  SettingsController,
  MyController
]
patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
bases.each do |base|
  base.send(:include, patch) unless base.included_modules.include?(patch)
end
