module RedmineBlockedReason
  module Patches
    module QueriesHelperPatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          alias_method :column_value_without_blocked_reason_tag, :column_value
          alias_method :column_value, :column_value_with_blocked_reason_tag
        end
      end

      module InstanceMethods
        def column_value_with_blocked_reason_tag(column, issue, value)
          tag = \
            if column.name.eql?(:subject)
              blocked_reason = issue.blocked_reason
              if blocked_reason
                render_blocked_reason_tag(blocked_reason)
              else
                ''
              end
            else
              ''
            end
          column_value_without_blocked_reason_tag(column, issue, value).to_s + tag.to_s
        end
      end
    end
  end
end

base = QueriesHelper
patch = RedmineBlockedReason::Patches::QueriesHelperPatch
base.send(:include, patch) unless base.included_modules.include?(patch)
