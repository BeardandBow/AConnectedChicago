class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :why, :text
    add_column :users, :where, :text
  end
end
