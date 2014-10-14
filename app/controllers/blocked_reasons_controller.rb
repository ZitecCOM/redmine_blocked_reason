class BlockedReasonsController < ApplicationController
  def create
    issue = Issue.find(params[:blocked_reason][:issue_id])
    if issue.editable?
      blocked_reason_type = BlockedReasonType.where(id: params[:blocked_reason][:blocked_reason_type][:id]).first
      redirect_to(issue, error: I18n.t('helpers.error.blocking_issue')) and return unless blocked_reason_type
      blocked_reason = BlockedReason.new comment: params[:blocked_reason][:comment],
        blocked_reason_type_id: blocked_reason_type[:id], issue_id: issue[:id], active: true,
        user_id: User.current.id, unblocker: false
      if blocked_reason.save
        journal = issue.init_journal(User.current, '')
        journal.details << JournalDetail.new(:property => 'attr',
                                             :prop_key => 'blocked_status',
                                             :value => I18n.t('blocked_reason'))
        journal.details << JournalDetail.new(:property => 'attr',
                                             :prop_key => 'blocked_reason',
                                             :value => blocked_reason.type_name)
        journal.details << JournalDetail.new(:property => 'attr',
                                             :prop_key => 'blocked_comment',
                                             :value => blocked_reason.comment)
        journal.save!
        redirect_to issue, notice: I18n.t('helpers.success.blocked_issue')
      else
        redirect_to issue, error: I18n.t('helpers.error.blocking_issue')
      end
    else
      redirect_to issue, error: I18n.t('helpers.error.blocked_permission_denied')
    end
  end

  def destroy
    issue = Issue.find(params[:blocked_reason][:issue_id])
    if issue.editable?
      blocked_reason = BlockedReason.where(issue_id: issue.id, active: true).first
      redirect_to issue, error: I18n.t('helpers.error.unblocking_issue') and return unless blocked_reason
      blocked_reason[:active] = false
      unblocked_reason = BlockedReason.new(
        blocked_reason_type_id: blocked_reason[:blocked_reason_type_id], unblocker: true,
        issue_id: issue[:id], active: false, user_id: User.current.id)
      if blocked_reason.save && unblocked_reason.save
        journal = issue.init_journal(User.current, '')
        journal.details << JournalDetail.new(:property => 'attr',
                                             :prop_key => 'blocked_status',
                                             :value => I18n.t('unblocked_reason'))
        journal.save!
        redirect_to issue, notice: I18n.t('helpers.success.unblocked_issue')
      else
        redirect_to issue, error: I18n.t('helpers.error.unblocking_issue')
      end
    else
      redirect_to issue, error: I18n.t('helpers.error.unblocked_permission_denied')
    end
  end
end
