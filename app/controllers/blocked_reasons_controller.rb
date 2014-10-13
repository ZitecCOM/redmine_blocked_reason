class BlockedReasonsController < ApplicationController
  def create
    issue = Issue.find(params[:blocked_reason][:issue_id])
    if issue.editable?
      blocked_reason_type = BlockedReasonType.find(params[:blocked_reason][:blocked_reason_type][:id])
      redirect_to(issue, error: 'Error blocking issue.') unless blocked_reason_type

      blocked_reason = BlockedReason.new comment: params[:blocked_reason][:comment], blocked_reason_type_id: blocked_reason_type[:id], issue_id: issue[:id]

      if blocked_reason.save
        journal = issue.init_journal(
          User.current,
           "#{I18n.t('blocked_reason')}: #{blocked_reason.type_name} \n #{blocked_reason.comment}"
        )
        journal.save
        redirect_to issue, notice: 'Issue is blocked.'
      else
        redirect_to issue, error: 'Error blocking issue.'
      end
    else
      redirect_to issue, error: 'You don\'t have permissions to block this issue.'
    end
  end

  def destroy
    issue = Issue.find(params[:blocked_reason][:issue_id])
    if issue.editable?
      blocked_reason = issue.blocked_reason
      if blocked_reason && blocked_reason.delete
        journal = issue.init_journal(User.current, I18n.t('unblocked_reason'))
        journal.save
        redirect_to issue, notice: 'Issue is unblocked.'
      else
        redirect_to issue, error: 'Error Unblocking issue.'
      end
    else
      redirect_to issue, error: 'You don\'t have permissions to block this issue.'
    end
  end

end
