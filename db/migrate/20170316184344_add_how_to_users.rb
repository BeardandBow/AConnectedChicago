class AddHowToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :how, :text
  end
end
