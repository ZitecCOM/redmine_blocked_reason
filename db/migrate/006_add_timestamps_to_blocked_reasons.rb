class AddTimestampsToBlockedReasons < ActiveRecord::Migration[4.2]
  def change
    add_column :blocked_reasons, :created_at, :datetime
    add_column :blocked_reasons, :updated_at, :datetime
  end
end