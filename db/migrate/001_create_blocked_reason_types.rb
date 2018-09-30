class CreateBlockedReasonTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :blocked_reason_types do |t|
      t.string :name
    end
  end
end
