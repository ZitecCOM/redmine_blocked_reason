class AddSettingsToBlockedReasonTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :blocked_reason_types, :blocked_reason_setting_id, :integer
    add_index :blocked_reason_types, :blocked_reason_setting_id
  end
end

