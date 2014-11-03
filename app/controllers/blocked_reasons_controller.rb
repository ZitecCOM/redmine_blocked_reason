class BlockedReasonsController < ApplicationController
  before_filter :issue_is_editable, :find_current_blocked_reason
  before_filter :find_blocked_reason_type, :create_new_blocked_reason_and_watcher,
    only: [:create, :update]

  def create
    saving_with_issue_transaction do
      if @current_blocked_reason
        @current_blocked_reason[:active] = false
        @current_blocked_reason.save!
      end
      @watcher.save!
      @new_blocked_reason.save!
      journal = @issue.init_journal(User.current, "#{@new_blocked_reason.comment}")
      journal.details << JournalDetail.new(:property => 'attr',
                                           :prop_key => 'blocked_status',
                                           :value => I18n.t('blocked_reason'))
      journal.details << JournalDetail.new(:property => 'attr',
                                           :prop_key => 'blocked_reason',
                                           :value => @new_blocked_reason.type_name)
      journal.save!
      @issue.touch
      redirect_to @issue, notice: I18n.t('helpers.success.blocked_issue')
    end
  end

  def update
    saving_with_issue_transaction do
      @current_blocked_reason[:active] = false
      @current_blocked_reason.save!
      @new_blocked_reason.save!
      @watcher.save!
      journal = @issue.init_journal(User.current, "#{@new_blocked_reason.comment}")
      if @current_blocked_reason.blocked_reason_type_id == @new_blocked_reason.blocked_reason_type_id
        journal.details << JournalDetail.new(:property => 'attr',
                                             :prop_key => 'blocked_reason',
                                             :value => @new_blocked_reason.type_name)
      else
        journal.details << JournalDetail.new(
          :property => 'attr',
          :prop_key => 'blocked_reason',
          :old_value => @current_blocked_reason.type_name,
          :value => @new_blocked_reason.type_name)
      end
      journal.save!
      @issue.touch
      redirect_to @issue, notice: I18n.t('helpers.success.blocked_issue')
    end
  end

  def destroy
    @current_blocked_reason[:active] = false
    comment = params[:blocked_reason][:comment].blank? ? I18n.t('unblocked_reason') :
      params[:blocked_reason][:comment]
    unblocked_reason = BlockedReason.new(comment: comment, unblocker: true,
      blocked_reason_type_id: @current_blocked_reason[:blocked_reason_type_id],
      issue_id: @issue[:id], active: false, user_id: User.current.id)
    saving_with_issue_transaction do
      @current_blocked_reason.save!
      unblocked_reason.save!
      journal = @issue.init_journal(User.current, "#{unblocked_reason.comment}")
      journal.details << JournalDetail.new(:property => 'attr',
                                           :prop_key => 'blocked_status',
                                           :value => I18n.t('unblocked_reason'))
      journal.save!
      @issue.touch
      redirect_to @issue, notice: I18n.t('helpers.success.unblocked_issue')
    end
  end

  private

  def issue_is_editable
    @issue = Issue.find(params[:blocked_reason][:issue_id])
    redirect_to(@issue, flash: {
      error: I18n.t('helpers.error.blocked_permission_denied')
    }) and return unless @issue.editable?
  end

  def find_blocked_reason_type
    @blocked_reason_type = BlockedReasonType.where(
      id: params[:blocked_reason][:blocked_reason_type][:id], removed: false).first
    redirect_to(@issue, flash: { error: I18n.t('helpers.error.blocking_issue') }) and
      return unless @blocked_reason_type
  end

  def find_current_blocked_reason
    @current_blocked_reason = BlockedReason.where(issue_id: @issue.id, active: true).first
    redirect_to @issue, flash: { error: I18n.t('helpers.error.unblocking_issue') } and
      return if @current_blocked_reason.nil? && params[:action] == :destroy
  end

  def create_new_blocked_reason_and_watcher
    comment = params[:blocked_reason][:comment].blank? ? I18n.t('blocked_reason') :
      params[:blocked_reason][:comment]
    @new_blocked_reason = BlockedReason.new(comment: comment,
      blocked_reason_type_id: @blocked_reason_type[:id], issue_id: @issue[:id],
      active: true, user_id: User.current.id, unblocker: false)
    @watcher = Watcher.where(watchable_type: 'Issue', watchable_id: @issue.id,
      user_id: User.current.id).first_or_create
  end

  def saving_with_issue_transaction
    begin
      Issue.transaction do
        begin
          yield
        rescue ActiveRecord::RecordInvalid => invalid
          logger.error invalid.message
          redirect_to @issue, flash: {
            error: params[:action] == :destroy ? I18n.t('helpers.error.unblocking_issue') :
              I18n.t('helpers.error.blocking_issue') }
        end
      end
    end
  end
end
