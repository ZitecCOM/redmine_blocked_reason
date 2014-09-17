class BlockedReasonsController < ApplicationController
  
  def create
    issue = Issue.find(params[:blocked_reason][:issue_id])
    if issue.editable?
      blocked_reason = BlockedReason.new (params[:blocked_reason])
      if blocked_reason.save
        journal = issue.init_journal(
            User.current, 
             "#{blocked_reason.type_name} : #{blocked_reason.comment}"
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

  
end
