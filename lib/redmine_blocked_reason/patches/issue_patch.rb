module RedmineBlockedReason
  module Patches
    module IssuePatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          has_one :blocked_reason
          around_save :unblock_issue
        end
      end

      module InstanceMethods
        private

        def unblock_issue
          @old_status_id_value = status_id_was
          yield
          return true if status_id == @old_status_id_value
          return true unless blocked_reason
          if blocked_reason.destroy
            journal = init_journal User.current, I18n.t('unblock_due_to_status_change')
            journal.details << JournalDetail.new(property: 'attr',
              prop_key: 'blocked_status', value: I18n.t('unblocked_reason'))
            journal.save!
          end
          true
        end
      end
    end
  end
end

base = Issue
patch = RedmineBlockedReason::Patches::IssuePatch
base.send(:include, patch) unless base.included_modules.include?(patch)
