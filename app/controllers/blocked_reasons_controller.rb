class BlockedReasonsController < ApplicationController
  def create
    issue = Issue.find(params[:blocked_reason][:issue_id])
    if issue.editable?
      blocked_reason_type = BlockedReasonType.find(params[:blocked_reason][:blocked_reason_type][:id])
      redirect_to(issue, error: I18n.t('helpers.error.blocking_issue')) unless blocked_reason_type
      blocked_reason = BlockedReason.new comment: params[:blocked_reason][:comment],
        blocked_reason_type_id: blocked_reason_type[:id], issue_id: issue[:id]
      if blocked_reason.save
        journal = issue.init_journal(User.current,
           "#{I18n.t('blocked_reason')}: #{blocked_reason.type_name} \n #{blocked_reason.comment}")
        journal.save
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
      blocked_reason = issue.blocked_reason
      if blocked_reason && blocked_reason.delete
        journal = issue.init_journal(User.current, I18n.t('unblocked_reason'))
        journal.save
        redirect_to issue, notice: I18n.t('helpers.success.unblocked_issue')
      else
        redirect_to issue, error: I18n.t('helpers.error.unblocking_issue')
      end
    else
      redirect_to issue, error: I18n.t('helpers.error.unblocked_permission_denied')
    end
  end
end
