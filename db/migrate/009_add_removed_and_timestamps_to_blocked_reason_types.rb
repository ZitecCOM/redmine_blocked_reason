class AddRemovedAndTimestampsToBlockedReasonTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :blocked_reason_types, :removed, :boolean, default: false
    add_column :blocked_reason_types, :created_at, :datetime
    add_column :blocked_reason_types, :updated_at, :datetime
  end
end
