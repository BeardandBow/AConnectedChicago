json.array! @orgs do |org|
  json.id org.id
  json.name org.name
  json.description org.description
  json.website org.website
  json.type org.type.name if org.type
  json.locations org.locations do |location|
    json.(location, :id, :address, :map_lat, :map_long)
  end
end
