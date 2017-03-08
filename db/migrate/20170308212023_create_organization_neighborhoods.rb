class CreateOrganizationNeighborhoods < ActiveRecord::Migration[5.0]
  def change
    create_table :organization_neighborhoods do |t|
      t.references :neighborhood, foreign_key: true
      t.references :organization, foreign_key: true
    end
  end
end
