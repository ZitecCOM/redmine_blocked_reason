class AddSettingsToBlockedReasons < ActiveRecord::Migration
  def change
    add_column :blocked_reasons, :blocked_reason_setting_id, :integer
    add_index :blocked_reasons, :blocked_reason_setting
  end
end

