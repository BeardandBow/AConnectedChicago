class CreateNeighborhoods < ActiveRecord::Migration[5.0]
  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.decimal :map_lat
      t.decimal :map_long
      t.timestamps
    end
  end
end
