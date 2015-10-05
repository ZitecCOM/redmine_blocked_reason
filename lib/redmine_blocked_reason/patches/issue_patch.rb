module RedmineBlockedReason
  module Patches
    module IssuePatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          unloadable
          has_many :blocked_reasons
          before_save :keep_old_status_id_value
          after_save :unblock_issue
        end
      end

      module InstanceMethods
        protected

        def keep_old_status_id_value
          @old_status_id_value = status_id_was
        end

        def unblock_issue
          return true if status_id == @old_status_id_value
          blocked_reason = BlockedReason.where(issue_id: id, active: true).first
          return true unless blocked_reason
          blocked_reason[:active] = false
          unblocked_reason = BlockedReason.new unblocker: true, issue_id: id,
            blocked_reason_type_id: blocked_reason[:blocked_reason_type_id],
            active: false, user_id: User.current.id
          if blocked_reason.save && unblocked_reason.save
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
base.send :include, patch unless base.included_modules.include? patch
