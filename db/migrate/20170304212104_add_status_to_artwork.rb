class AddStatusToArtwork < ActiveRecord::Migration[5.0]
  def change
    add_column :artworks, :status, :integer, default: 0
  end
end
