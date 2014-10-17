class BlockedReasonsController < ApplicationController
  def create
    issue = Issue.find(params[:blocked_reason][:issue_id])
    if issue.editable?
      blocked_reason_type = BlockedReasonType.where(
        id: params[:blocked_reason][:blocked_reason_type][:id], removed: false).first
      redirect_to(issue, error: I18n.t('helpers.error.blocking_issue')) and
        return unless blocked_reason_type
      current_blocked_reason = BlockedReason.where(issue_id: issue.id, active: true).first
      blocked_reason = BlockedReason.new comment: params[:blocked_reason][:comment],
        blocked_reason_type_id: blocked_reason_type[:id], issue_id: issue[:id],
        active: true, user_id: User.current.id, unblocker: false
      watcher = Watcher.where(watchable_type: 'Issue', watchable_id: issue.id,
        user_id: User.current.id
        ).first || Watcher.new(watchable_type: 'Issue', watchable_id: issue.id,
        user_id: User.current.id)
      begin
        Issue.transaction do
          if current_blocked_reason
            current_blocked_reason[:active] = false
            current_blocked_reason.save!
          end
          watcher.save!
          blocked_reason.save!
          journal = issue.init_journal(User.current, "#{blocked_reason.comment}")
          journal.details << JournalDetail.new(:property => 'attr',
                                               :prop_key => 'blocked_status',
                                               :value => I18n.t('blocked_reason'))
          journal.details << JournalDetail.new(:property => 'attr',
                                               :prop_key => 'blocked_reason',
                                               :value => blocked_reason.type_name)
          journal.save!
          issue.touch
          redirect_to issue, notice: I18n.t('helpers.success.blocked_issue')
        end
      rescue ActiveRecord::RecordInvalid => invalid
        logger.error invalid.message
        redirect_to issue, error: I18n.t('helpers.error.blocking_issue')
      end
    else
      redirect_to issue, error: I18n.t('helpers.error.blocked_permission_denied')
    end
  end

  def update
    issue = Issue.find(params[:blocked_reason][:issue_id])
    if issue.editable?
      blocked_reason_type = BlockedReasonType.where(
        id: params[:blocked_reason][:blocked_reason_type][:id], removed: false).first
      redirect_to(issue, error: I18n.t('helpers.error.blocking_issue')) and
        return unless blocked_reason_type
      current_blocked_reason = BlockedReason.where(issue_id: issue.id, active: true).first
      blocked_reason = BlockedReason.new comment: params[:blocked_reason][:comment],
        blocked_reason_type_id: blocked_reason_type[:id], issue_id: issue[:id],
        active: true, user_id: User.current.id, unblocker: false
      watcher = Watcher.where(watchable_type: 'Issue', watchable_id: issue.id,
        user_id: User.current.id
        ).first || Watcher.new(watchable_type: 'Issue', watchable_id: issue.id,
        user_id: User.current.id)
      begin
        Issue.transaction do
          current_blocked_reason[:active] = false
          current_blocked_reason.save!
          blocked_reason.save!
          watcher.save!
          journal = issue.init_journal(User.current, "#{blocked_reason.comment}")
          if current_blocked_reason.blocked_reason_type_id == blocked_reason.blocked_reason_type_id
            journal.details << JournalDetail.new(:property => 'attr',
                                                 :prop_key => 'blocked_reason',
                                                 :value => blocked_reason.type_name)
          else
            journal.details << JournalDetail.new(
              :property => 'attr',
              :prop_key => 'blocked_reason',
              :old_value => current_blocked_reason.type_name,
              :value => blocked_reason.type_name)
          end
          journal.save!
          issue.touch
          redirect_to issue, notice: I18n.t('helpers.success.blocked_issue')
        end
      rescue ActiveRecord::RecordInvalid => invalid
        logger.error invalid.message
        redirect_to issue, error: I18n.t('helpers.error.blocking_issue')
      end
    else
      redirect_to issue, error: I18n.t('helpers.error.blocked_permission_denied')
    end
  end

  def destroy
    issue = Issue.find(params[:issue_id])
    if issue.editable?
      blocked_reason = BlockedReason.where(issue_id: issue.id, active: true).first
      redirect_to issue, error: I18n.t('helpers.error.unblocking_issue') and
        return unless blocked_reason
      blocked_reason[:active] = false
      unblocked_reason = BlockedReason.new(
        blocked_reason_type_id: blocked_reason[:blocked_reason_type_id], unblocker: true,
        issue_id: issue[:id], active: false, user_id: User.current.id)
      begin
        Issue.transaction do
          blocked_reason.save!
          unblocked_reason.save!
          journal = issue.init_journal(User.current, "#{blocked_reason.comment}")
          journal.details << JournalDetail.new(:property => 'attr',
                                               :prop_key => 'blocked_status',
                                               :value => I18n.t('unblocked_reason'))
          journal.save!
          issue.touch
          redirect_to issue, notice: I18n.t('helpers.success.unblocked_issue')
        end
      rescue ActiveRecord::RecordInvalid => invalid
        logger.error invalid.message
        redirect_to issue, error: I18n.t('helpers.error.unblocking_issue')
      end
    else
      redirect_to issue, error: I18n.t('helpers.error.unblocked_permission_denied')
    end
  end
end
