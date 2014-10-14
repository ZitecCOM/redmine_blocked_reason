class BlockedReasonTypeController < ApplicationController
  layout 'admin'
  before_filter :require_admin

  def new
    @blocked_reason_type = BlockedReasonType.new
  end

  def create
    @blocked_reason_type = BlockedReasonType.new(params[:blocked_reason_type])
    if @blocked_reason_type.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to blocked_reason_settings_path
    else
      render :new
    end
  end

  def edit
    @blocked_reason_type = BlockedReasonType.find(params[:id])
  end

  def update
    @blocked_reason_type = BlockedReasonType.find(params[:id])
    if @blocked_reason_type.update_attributes(params[:blocked_reason_type])
      flash[:notice] = l(:notice_successful_update)
      redirect_to blocked_reason_settings_path
    else
      render :edit
    end
  end

  def destroy
    @blocked_reason_type = BlockedReasonType.find(params[:id])
    @blocked_reason_type.destroy
    flash[:notice] = l(:notice_successful_delete)
    redirect_to blocked_reason_settings_path
  end
end
