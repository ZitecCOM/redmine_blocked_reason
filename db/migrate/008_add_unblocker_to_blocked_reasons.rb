class AddUnblockerToBlockedReasons < ActiveRecord::Migration[4.2]
  def change
    add_column :blocked_reasons, :unblocker, :boolean
  end
end