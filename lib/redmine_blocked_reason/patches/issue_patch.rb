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
        def blocked_reason_tag
          blocked_reason = BlockedReason.where(issue_id: id, active: true).first
          if blocked_reason
             return "<span data-tip='#{blocked_reason.comment}' class='tip blocked_reason_tag'>#{I18n.t 'blocked_reason'}: #{blocked_reason.type_name}</span>".html_safe
          end
          return ''
        end
      end
    end

  end
end

unless Issue.included_modules.include?(RedmineBlockedReason::Patches::IssuePatch)
  Issue.send(:include, RedmineBlockedReason::Patches::IssuePatch)
end
