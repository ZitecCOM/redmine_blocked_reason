require_dependency 'queries_helper'
if ActiveSupport::Dependencies::search_for_file('issue_queries_helper')
  require_dependency 'issue_queries_query'
end

module RedmineBlockedReason
  module Patches
    module BlockedReasonQueriesHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

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

base = ActiveSupport::Dependencies::search_for_file('issue_queries_helper') ? IssueQueriesHelper : QueriesHelper
unless base.included_modules.include?(RedmineBlockedReason::Patches::BlockedReasonQueriesHelperPatch)
  base.send(:include, RedmineBlockedReason::Patches::BlockedReasonQueriesHelperPatch)
end
