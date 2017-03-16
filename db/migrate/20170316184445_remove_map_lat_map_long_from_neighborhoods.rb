class RemoveMapLatMapLongFromNeighborhoods < ActiveRecord::Migration[5.0]
  def change
    remove_column :neighborhoods, :map_lat, :string
    remove_column :neighborhoods, :map_long, :string
  end
end
