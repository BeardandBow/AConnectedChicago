class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.references :organization, foreign_key: true
      t.references :neighborhood, foreign_key: true
      t.string :address
      t.decimal :map_lat
      t.decimal :map_long
      t.timestamps
    end
  end
end
