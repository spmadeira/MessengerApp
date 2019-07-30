class AddDeletedAtToInvite < ActiveRecord::Migration[5.2]
  def change
    add_column :invites, :deleted_at, :datetime
    add_index :invites,:deleted_at
  end
end
