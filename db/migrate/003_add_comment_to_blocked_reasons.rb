class AddCommentToBlockedReasons < ActiveRecord::Migration
  def change
    add_column :blocked_reasons, :comment, :text
  end
end

