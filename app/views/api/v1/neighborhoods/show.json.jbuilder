json.name @hood.name
json.bounds @hood.bounds
json.events @events do |event|
  json.(event, :id,
              :title,
              :host_contact,
              :description,
              :map_lat,
              :map_long,
              :formatted_date_time,
              :image,
              :address,
              :status,
              :pkey)
  json.type event.type.name
end
json.artworks @artworks
json.stories @stories
