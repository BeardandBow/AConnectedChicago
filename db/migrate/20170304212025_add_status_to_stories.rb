class AddStatusToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :status, :integer, default: 0
  end
end
