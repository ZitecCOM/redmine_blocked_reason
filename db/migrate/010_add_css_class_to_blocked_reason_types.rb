class AddCssClassToBlockedReasonTypes < ActiveRecord::Migration
  def change
    add_column :blocked_reason_types, :css_class, :string
  end
end
