class AddYoutubeLinkToStory < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :youtube_link, :string
  end
end
