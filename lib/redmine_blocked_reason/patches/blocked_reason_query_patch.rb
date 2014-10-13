module RedmineBlockedReason
  module BlockedReasonQueryPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :available_filters, :blocked_reasons
      end
    end
    module InstanceMethods
      def available_filters_with_blocked_reasons
        @available_filters = available_filters_without_blocked_reasons
        blocked_reason_filters = {
          "parent_id" => {
            :name => 'parent',
            :type => :integer,
            :order => @available_filters.size + 1},
          "root_id" => {
            :name => 'root',
            :type => :integer,
            :order => @available_filters.size + 2}
        }
        @available_filters.merge!(blocked_reason_filters)
      end
    end
  end
end

# Add module to Query
unless Query.included_modules.include?(RedmineBlockedReason::BlockedReasonQueryPatch)
  Query.send(:include, RedmineBlockedReason::BlockedReasonQueryPatch)
end
