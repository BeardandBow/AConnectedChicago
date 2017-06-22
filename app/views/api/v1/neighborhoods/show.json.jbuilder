json.name @hood.name
json.bounds @hood.bounds
json.locations @hood.locations.includes(:organization) do |location|
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
  json.id event.id
  json.title event.title
  json.host_contact event.host_contact
  json.description event.description
  json.map_lat event.map_lat
  json.map_long event.map_long
  json.formatted_date_time event.formatted_date_time
  json.image_url event.image.url
  json.thumb_url event.image.thumb.url
  json.address event.address
  json.status event.status
  json.pkey event.pkey
  json.type event.type.name
  json.organization do
    json.name event.organization.name
    json.website event.organization.website
  end
end
json.artworks @artworks do |artwork|
  json.id artwork.id
  json.title artwork.title
  json.artist artwork.artist
  json.description artwork.description
  json.map_lat artwork.map_lat
  json.map_long artwork.map_long
  json.formatted_create_time artwork.formatted_create_time
  json.image_url artwork.image.url
  json.thumb_url artwork.image.thumb.url
  json.address artwork.address
  json.status artwork.status
  json.pkey artwork.pkey
end
json.stories @stories do |story|
  json.id story.id
  json.title story.title
  json.author story.author
  json.description story.description
  json.map_lat story.map_lat
  json.map_long story.map_long
  json.formatted_create_time story.formatted_create_time
  json.image_url story.image.url
  json.thumb_url story.image.thumb.url
  json.address story.address
  json.status story.status
  json.pkey story.pkey
end
