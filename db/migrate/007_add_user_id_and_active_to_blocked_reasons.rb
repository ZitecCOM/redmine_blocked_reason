class AddUserIdAndActiveToBlockedReasons < ActiveRecord::Migration[4.2]
  def change
    add_column :blocked_reasons, :user_id, :integer
    add_column :blocked_reasons, :active, :boolean
  end
end