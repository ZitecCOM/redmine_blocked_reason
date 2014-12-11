require_dependency 'issue'

module RedmineBlockedReason
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          has_one :blocked_reason
          before_save :keep_old_status_id_value
          after_save :unblock_issue
        end
      end

      module InstanceMethods

        protected

        def unblock_issue
          return true if status_id == @old_status_id_value
          blocked_reason = BlockedReason.where(issue_id: id, active: true).first
          return true unless blocked_reason
          blocked_reason[:active] = false
          unblocked_reason = BlockedReason.new(
            blocked_reason_type_id: blocked_reason[:blocked_reason_type_id], unblocker: true,
            issue_id: id, active: false, user_id: User.current.id)
          if blocked_reason.save && unblocked_reason.save
            journal = init_journal(User.current, I18n.t('unblock_due_to_status_change'))
            journal.details << JournalDetail.new(:property => 'attr',
                                                 :prop_key => 'blocked_status',
                                                 :value => I18n.t('unblocked_reason'))
            journal.save!
          end
          true
        end

        def keep_old_status_id_value
          @old_status_id_value = status_id_was
        end
      end
    end
  end
end

unless Issue.included_modules.include?(RedmineBlockedReason::Patches::IssuePatch)
  Issue.send(:include, RedmineBlockedReason::Patches::IssuePatch)
end
