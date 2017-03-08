class AddForeignKeyToUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :neighborhood, foreign_key: true
  end
end
