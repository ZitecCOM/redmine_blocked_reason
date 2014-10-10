class CreateBlockedReasonSettings < ActiveRecord::Migration
  def change
    create_table :blocked_reason_settings do |t|
      t.boolean :enabled, default: false
      t.references :project
    end
  end
end
