class AddImageToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :image, :string
  end
end
