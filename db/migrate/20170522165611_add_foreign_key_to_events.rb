class AddForeignKeyToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :type, foreign_key: true
  end
end
