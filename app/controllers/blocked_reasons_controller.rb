class BlockedReasonsController < ApplicationController
  before_filter :issue_is_editable, :find_current_blocked_reason
  before_filter :find_blocked_reason_type,
    :create_new_blocked_reason_and_watcher, only: [:create, :update]

  def create
    saving_with_issue_transaction do
      if @current_blocked_reason
        @current_blocked_reason.active = false
        @current_blocked_reason.save!
      end
      @watcher.save!
      @new_blocked_reason.save!
      comment = @new_blocked_reason.comment || ''
      journal = @issue.init_journal User.current, comment
      journal.details << JournalDetail.new(property: 'attr',
        prop_key: 'blocked_status', value: I18n.t('blocked_reason'))
      journal.details << JournalDetail.new(property: 'attr',
        prop_key: 'blocked_reason', value: @new_blocked_reason.type_name)
      journal.save!
      @issue.touch
      render json: { success: I18n.t('helpers.success.blocked_issue') }
    end
  end

  def update
    saving_with_issue_transaction do
      @current_blocked_reason.active = false
      @current_blocked_reason.save!
      @new_blocked_reason.save!
      @watcher.save!
      comment = @new_blocked_reason.comment || ''
      journal = @issue.init_journal User.current, comment
      if @current_blocked_reason.blocked_reason_type_id ==
          @new_blocked_reason.blocked_reason_type_id
        journal.details << JournalDetail.new(property: 'attr',
          prop_key: 'blocked_reason', value: @new_blocked_reason.type_name)
      else
        journal.details << JournalDetail.new(property: 'attr',
          prop_key: 'blocked_reason', value: @new_blocked_reason.type_name,
          old_value: @current_blocked_reason.type_name)
      end
      journal.save!
      @issue.touch
      render json: { success: I18n.t('helpers.success.blocked_issue') }
    end
  end

  def destroy
    @current_blocked_reason.active = false
    comment = params[:blocked_reason][:comment]
    comment = I18n.t('unblocked_reason') if comment.blank?
    unblocked_reason = BlockedReason.new(comment: comment, unblocker: true,
      blocked_reason_type_id: @current_blocked_reason[:blocked_reason_type_id],
      issue_id: @issue.id, active: false, user_id: User.current.id)
    saving_with_issue_transaction do
      @current_blocked_reason.save!
      unblocked_reason.save!
      journal = @issue.init_journal User.current, unblocked_reason.comment
      journal.details << JournalDetail.new(property: 'attr',
        prop_key: 'blocked_status', value: I18n.t('unblocked_reason'))
      journal.save!
      @issue.touch
      render json: { success: I18n.t('helpers.success.unblocked_issue') }
    end
  end

  private

  def issue_is_editable
    @issue = Issue.find params[:blocked_reason][:issue_id]
    redirect_to @issue, flash: {
      error: I18n.t('helpers.error.blocked_permission_denied')
    } and return unless @issue.editable?
  end

  def find_blocked_reason_type
    @blocked_reason_type = BlockedReasonType.where(removed: false,
      id: params[:blocked_reason][:blocked_reason_type][:id]).first
    redirect_to @issue,
      flash: { error: I18n.t('helpers.error.blocking_issue') } and
        return unless @blocked_reason_type
  end

  def find_current_blocked_reason
    @current_blocked_reason = BlockedReason.where(issue_id: @issue.id,
      active: true).first
    redirect_to @issue,
      flash: { error: I18n.t('helpers.error.unblocking_issue') } and
        return if @current_blocked_reason.nil? && params[:action] == :destroy
  end

  def create_new_blocked_reason_and_watcher
    comment = params[:blocked_reason][:comment]
    comment = I18n.t('blocked_reason') if comment.blank?
    @new_blocked_reason = BlockedReason.new comment: comment,
      blocked_reason_type_id: @blocked_reason_type[:id], issue_id: @issue.id,
      active: true, user_id: User.current.id, unblocker: false
    @watcher = Watcher.where(watchable_type: 'Issue', watchable_id: @issue.id,
      user_id: User.current.id).first_or_create
  end

  def saving_with_issue_transaction
    begin
      Issue.transaction do
        begin
          yield
        rescue ActiveRecord::RecordInvalid => error
          logger.error error.message
          error_text = if params[:action] == :destroy
              I18n.t('helpers.error.unblocking_issue')
            else
              I18n.t('helpers.error.blocking_issue')
            end
          render json: { error: error_text }, status: 400
        end
      end
    end
  end
end
