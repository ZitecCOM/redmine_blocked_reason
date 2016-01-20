module RedmineBlockedReason
  module Patches
    module QueryPatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          alias_method_chain :sql_for_field, :blocked_reasons

          alias_method :available_filters_without_blocked_reasons, :available_filters
          alias_method :available_filters, :available_filters_with_blocked_reasons
        end
      end
      module InstanceMethods
        def available_filters_with_blocked_reasons
          unless @available_filters
            available_filters_without_blocked_reasons.merge!({
              'blocked_reason' => { name: 'Blocked Reason', order: 201,
                type: :list_optional,
                values: BlockedReasonType.where(removed: false).map {|b| [b.name, b.id.to_s] }
              }
            })
          end
          @available_filters
        end

        def sql_for_field_with_blocked_reasons(field, operator, value, db_table, db_field, is_custom_filter = false)
          if field == 'blocked_reason'
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
                WHERE br.active = true AND br.unblocker = false AND brt.removed = false"
            if operator == '='
              sql << " AND brt.id IN (#{brt_ids})"
            elsif operator == '!'
              sql << " AND brt.id IN (#{brt_ids})"
            end
            sql << ')'
            return sql
          else
            return sql_for_field_without_blocked_reasons(field, operator, value, db_table, db_field, is_custom_filter)
          end
        end
      end
    end
  end
end

base = Query
patch = RedmineBlockedReason::Patches::QueryPatch
base.send(:include, patch) unless base.included_modules.include?(patch)
