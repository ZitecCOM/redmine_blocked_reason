module RedmineBlockedReason
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          alias_method :index_without_blocked_reason, :index
          alias_method :index, :index_with_blocked_reason
        end
      end

      module InstanceMethods

        def index_with_blocked_reason
          index_without_blocked_reason
        end
      end
    end
  end
end

base = IssuesController
patch = RedmineBlockedReason::Patches::IssuesControllerPatch
base.send :include, patch unless base.included_modules.include? patch
