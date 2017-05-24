class AddForeignKeyToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_reference :organizations, :type, foreign_key: true
  end
end
