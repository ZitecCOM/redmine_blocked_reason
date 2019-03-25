class AddCommentToBlockedReasons < ActiveRecord::Migration[4.2]
  def change
    add_column :blocked_reasons, :comment, :text
  end
end

