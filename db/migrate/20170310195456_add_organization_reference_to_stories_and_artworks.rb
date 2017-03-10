class AddOrganizationReferenceToStoriesAndArtworks < ActiveRecord::Migration[5.0]
  def change
    add_reference :stories, :organization, foreign_key: true
    add_reference :artworks, :organization, foreign_key: true
  end
end
