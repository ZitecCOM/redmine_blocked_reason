require_dependency 'issue'

module RedmineBlockedReason
  module Patches

    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          has_one :blocked_reason
        end
      end

      module InstanceMethods
      end
    end

  end
end

unless Issue.included_modules.include?(RedmineBlockedReason::Patches::IssuePatch)
  Issue.send(:include, RedmineBlockedReason::Patches::IssuePatch)
end
