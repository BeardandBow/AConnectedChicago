class AddFormattedDateTimeToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :formatted_date_time, :string
  end
end
