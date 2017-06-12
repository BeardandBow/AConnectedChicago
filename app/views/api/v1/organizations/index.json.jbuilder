json.array! @orgs do |org|
  json.name org.name
  json.description org.description
  json.website org.website
  json.type org.type.name if org.type
end
