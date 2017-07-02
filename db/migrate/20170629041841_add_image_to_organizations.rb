class AddImageToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :image, :string
  end
end
