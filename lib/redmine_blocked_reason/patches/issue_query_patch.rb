module RedmineBlockedReason
  module Patches
    module IssueQueryPatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          unloadable

          alias_method_chain :available_filters, :blocked_reason
        end
      end
      module InstanceMethods
        def available_filters_with_blocked_reason
          if @available_filters.blank?

            add_available_filter('blocked_reason', :type => :list_optional, :name => l(:field_blocked_reason),
              values: BlockedReasonType.select([:id, :name]).map {|b| [b.name, b.id.to_s] }) unless available_filters_without_blocked_reason.key?('blocked_reason')
          else
            @available_filters_without_blocked_reason
          end
          @available_filters
        end

        def sql_for_blocked_reason_field(field, operator, value)
          case operator
          when '='
            containment_type = 'IN'
          when '!'
            containment_type = 'NOT IN'
          when '*'
            containment_type = 'IN'
          when '!*'
            containment_type = 'NOT IN'
          end

          brt_ids = value.map {|v| v.to_i}.join(',')
          sql = "issues.id #{containment_type} (
              SELECT DISTINCT i.id FROM issues i
                INNER JOIN blocked_reasons br ON br.issue_id = i.id
                INNER JOIN blocked_reason_types brt ON br.blocked_reason_type_id = brt.id
          "

          if operator == '='
            sql << " AND brt.id IN (#{brt_ids})"
          elsif operator == '!'
            sql << " AND brt.id IN (#{brt_ids})"
          end

          sql << ')'

          return sql
        end
      end
    end
  end
end

base = IssueQuery
patch = RedmineBlockedReason::Patches::IssueQueryPatch
base.send(:include, patch) unless base.included_modules.include?(patch)
