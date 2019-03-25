class AddCssClassToBlockedReasonTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :blocked_reason_types, :css_class, :string
  end
end
