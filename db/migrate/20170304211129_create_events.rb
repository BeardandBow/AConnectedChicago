class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :host_contact
      t.string :description
      t.decimal :map_lat
      t.decimal :map_long
      t.string :address
      t.date :date
      t.time :time
      t.string :pkey
      t.references :user, foreign_key: true
      t.references :neighborhood, foreign_key: true
      t.timestamps
    end
  end
end
