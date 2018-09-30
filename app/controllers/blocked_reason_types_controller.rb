class BlockedReasonTypesController < ApplicationController
  layout 'admin'
  before_action :require_admin

  def new
    @blocked_reason_type = BlockedReasonType.new
  end

  def create
    @blocked_reason_type = BlockedReasonType.new reason_params
    if @blocked_reason_type.save
      flash[:notice] = l :notice_successful_create
      redirect_to blocked_reason_settings_path
    else
      render :new
    end
  end

  def edit
    @blocked_reason_type = BlockedReasonType.find params[:id]
  end

  def update
    @blocked_reason_type = BlockedReasonType.find params[:id]
    if @blocked_reason_type.update_attributes reason_params
      flash[:notice] = l :notice_successful_update
      redirect_to blocked_reason_settings_path
    else
      render :edit
    end
  end

  def destroy
    @blocked_reason_type = BlockedReasonType.find params[:id]
    @blocked_reason_type.removed = true
    if @blocked_reason_type.save
      flash[:notice] = l :notice_successful_delete
    else
      flash[:error] = l 'helper.error.delete_blocked_reason_type'
    end
    redirect_to blocked_reason_settings_path
  end

  private

  def reason_params
    params.require(:blocked_reason_type).permit!
  end
end
