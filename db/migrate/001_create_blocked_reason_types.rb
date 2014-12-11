class CreateBlockedReasonTypes < ActiveRecord::Migration
  def change
    create_table :blocked_reason_types do |t|
      t.string :name
    end
  end
end
