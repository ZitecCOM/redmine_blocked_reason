class BlockedReasonsController < ApplicationController
  before_action :issue_is_editable, :find_current_blocked_reason
  before_action :find_blocked_reason_type,
    :create_new_blocked_reason_and_watcher, only: [:create, :update]

  def create
    saving_with_issue_transaction do
      @current_blocked_reason.destroy if @current_blocked_reason
      @watcher.save!
      @new_blocked_reason.save!

      comment = @new_blocked_reason.comment || ''
      journal = @issue.init_journal(User.current, comment)
      journal.details << JournalDetail.new(
        prop_key: 'blocked_status',
        property: 'attr',
        value:    I18n.t('blocked_reason')
      )
      journal.details << JournalDetail.new(
        property: 'attr',
        prop_key: 'blocked_reason',
        value:    @new_blocked_reason.type_name
      )
      journal.save!

      @issue.touch
      render json: {success: I18n.t('helpers.success.blocked_issue')}
    end
  end

  def update
    saving_with_issue_transaction do
      @current_blocked_reason.destroy
      @new_blocked_reason.save!
      @watcher.save!

      comment = @new_blocked_reason.comment || ''
      journal = @issue.init_journal(User.current, comment)
      if @current_blocked_reason.blocked_reason_type_id ==
          @new_blocked_reason.blocked_reason_type_id
        journal.details << JournalDetail.new(
          prop_key: 'blocked_reason',
          property: 'attr',
          value:    @new_blocked_reason.type_name
        )
      else
        journal.details << JournalDetail.new(
          old_value: @current_blocked_reason.type_name,
          prop_key:  'blocked_reason',
          property:  'attr',
          value:     @new_blocked_reason.type_name
        )
      end
      journal.save!

      @issue.touch
      render json: {success: I18n.t('helpers.success.blocked_issue')}
    end
  end

  def destroy
    comment = params[:blocked_reason][:comment]
    comment = I18n.t('unblocked_reason') if comment.blank?
    saving_with_issue_transaction do
      @current_blocked_reason.destroy!

      journal = @issue.init_journal(User.current, comment)
      journal.details << JournalDetail.new(
        prop_key: 'blocked_status',
        property: 'attr',
        value:    I18n.t('unblocked_reason')
      )
      journal.save!

      @issue.touch
      render json: {success: I18n.t('helpers.success.unblocked_issue')}
    end
  end

  private

  def issue_is_editable
    @issue = Issue.find params[:blocked_reason][:issue_id]
    render json: { error: I18n.t('helpers.error.blocked_permission_denied') },
      status: 400 and return unless @issue.editable?
  end

  def find_blocked_reason_type
    type_id = params[:blocked_reason][:blocked_reason_type][:id]
    @blocked_reason_type = BlockedReasonType.where(id: type_id).first
    return if @blocked_reason_type
    render(
      json:   { error: I18n.t('helpers.error.blocking_issue') },
      status: 400
    )
  end

  def find_current_blocked_reason
    @current_blocked_reason = BlockedReason.where(issue_id: @issue.id).first
    return unless !@current_blocked_reason && params[:action] == :destroy
    render(
      json:   { error: I18n.t('helpers.error.unblocking_issue') },
      status: 400
    )
  end

  def create_new_blocked_reason_and_watcher
    comment = params[:blocked_reason][:comment]
    comment = I18n.t('blocked_reason') if comment.blank?

    @new_blocked_reason = BlockedReason.new(
      comment:                comment,
      blocked_reason_type_id: @blocked_reason_type[:id],
      issue_id:               @issue.id,
      user_id:                User.current.id
    )

    @watcher = Watcher.where(
      watchable_type: 'Issue',
      watchable_id:   @issue.id,
      user_id:        User.current.id
    ).first_or_create
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
