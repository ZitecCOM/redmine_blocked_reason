class BlockedReasonSettingsController < ApplicationController
  unloadable
  before_filter :find_user
  # before_filter :authorize

  def index
  end

  private

  def find_user
    @user = User.current
  end
end
