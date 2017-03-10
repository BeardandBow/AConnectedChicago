class CreateJoinTableOrganizationUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :organization_users do |t|
      t.references :user, foreign_key: true
      t.references :organization, foreign_key: true
    end
  end
end
