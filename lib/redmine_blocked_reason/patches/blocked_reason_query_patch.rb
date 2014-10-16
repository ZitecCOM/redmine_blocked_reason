module RedmineBlockedReason
  module BlockedReasonQueryPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :available_filters, :blocked_reasons
        alias_method_chain :sql_for_field, :blocked_reasons
      end
    end
    module InstanceMethods
      def available_filters_with_blocked_reasons
        @available_filters = available_filters_without_blocked_reasons
        blocked_reason_filters = {
          "blocked_reason" => {
            :name => 'Blocked Reason',
            :type => :list,
            :values => BlockedReasonType.where(removed: false).map {|b| [b.name, b.id.to_s] },
            :order => @available_filters.size + 1}
        }
        @available_filters.merge!(blocked_reason_filters)
      end

      def sql_for_field_with_blocked_reasons(field, operator, value, db_table, db_field, is_custom_filter=false)
        if field == 'blocked_reason'
          brt_ids = value.map {|v| v.to_i}.join(',')
          "issues.id IN (
              SELECT DISTINCT i.id FROM issues i
                INNER JOIN blocked_reasons br ON br.issue_id = i.id
                INNER JOIN blocked_reason_types brt ON br.blocked_reason_type_id = brt.id
              WHERE br.active = true AND br.unblocker = false AND brt.removed = false
              AND brt.id in (#{brt_ids})
            )"
        else
          return sql_for_field_without_blocked_reasons(field, operator, value, db_table, db_field, is_custom_filter)
        end
      end
    end
  end
end

# Add module to Query
unless Query.included_modules.include?(RedmineBlockedReason::BlockedReasonQueryPatch)
  Query.send(:include, RedmineBlockedReason::BlockedReasonQueryPatch)
end
