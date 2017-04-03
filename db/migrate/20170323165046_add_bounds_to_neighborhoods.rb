class AddBoundsToNeighborhoods < ActiveRecord::Migration[5.0]
  def change
    add_column :neighborhoods, :bounds, :json, default: []
  end
end
