class AddDeletedAtToAllTables < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deleted_at, :datetime
    add_index :users,:deleted_at
    add_column :groups, :deleted_at, :datetime
    add_index :groups,:deleted_at
    add_column :messages, :deleted_at, :datetime
    add_index :messages,:deleted_at
    add_column :user_groups, :deleted_at, :datetime
    add_index :user_groups,:deleted_at
  end
end
