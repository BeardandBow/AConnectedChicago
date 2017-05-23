class RemoveEventTypeFromEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :type.name, :string
  end
end
