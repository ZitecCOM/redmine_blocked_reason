class CreateBlockedReasons < ActiveRecord::Migration
  def change
    create_table :blocked_reasons do |t|
      t.references :issue
      t.references :blocked_reason_type
    end

    add_index :blocked_reasons, :issue_id
    add_index :blocked_reasons, :blocked_reason_type_id
  end
end
