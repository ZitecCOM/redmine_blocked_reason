class AddUnblockerToBlockedReasons < ActiveRecord::Migration
  def change
    add_column :blocked_reasons, :unblocker, :boolean
  end
end