class RemoveUnusedColumns < ActiveRecord::Migration[4.2]
  def up
    remove_column :blocked_reasons, :active
    remove_column :blocked_reasons, :unblocker
    remove_column :blocked_reason_types, :removed
  end

  def down
    add_column :blocked_reasons, :active, :boolean
    add_column :blocked_reasons, :unblocker, :boolean
    add_column :blocked_reason_types, :removed, :boolean
  end
end
