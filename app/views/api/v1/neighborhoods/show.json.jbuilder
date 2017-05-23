json.name @hood.name
json.bounds @hood.bounds
json.locations @hood.locations do |location|
  json.(location, :id, :address, :map_lat, :map_long)
  json.organization do
    json.id location.organization.id
    json.name location.organization.name
    json.description location.organization.description
    json.website location.organization.website
    json.type location.organization.type.name
  end
end
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
