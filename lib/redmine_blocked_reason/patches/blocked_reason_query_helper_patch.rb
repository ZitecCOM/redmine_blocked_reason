module RedmineBlockedReason
  module Patches
    module BlockedReasonQueriesHelperPatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          unloadable
          alias_method_chain :column_value, :blocked_reason_tag
        end
      end

      module InstanceMethods
        def column_value_with_blocked_reason_tag(column, issue, value)
          tag = column.name.eql?(:subject) ? render('blocked_reason/blocked_reason_tag', issue: issue) : ''
          column_value_without_blocked_reason_tag(column, issue, value).to_s + tag.to_s
        end
      end
    end
  end
end

base = QueriesHelper
new_module = RedmineBlockedReason::Patches::BlockedReasonQueriesHelperPatch
base.send :include, new_module unless base.included_modules.include? new_module
