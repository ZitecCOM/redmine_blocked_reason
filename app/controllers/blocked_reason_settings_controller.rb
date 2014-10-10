class BlockedReasonSettingsController < ApplicationController
  unloadable
  before_filter :find_project, :find_user
  # before_filter :authorize

  def index
    @blocked_reason_setting = BlockedReasonSetting.find_or_create(@project.id)
    if @blocked_reason_setting.id
      @blocked_reason_types = BlockedReasonType.where(blocked_reason_setting_id: @blocked_reason_setting.id)
    else
      @blocked_reason_types = []
    end
  end

  def new
  end

  def edit
    if params[:settings] != nil
      @blocked_reason_setting = BlockedReasonSetting.find_or_create(@project.id)
      attribute = params[:settings]
      @blocked_reason_setting.update_attributes(enabled: attribute[:enabled],
        name: attribute[:help_message])
      flash[:notice] = l(:notice_successful_update)
      redirect_to controller: 'projects', action: 'settings', id: @project,
        tab: 'blocked_reasons'
    end
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def find_user
    @user = User.current
  end

  def find_project
    begin
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end
