class AddWebsiteToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :website, :string
  end
end
