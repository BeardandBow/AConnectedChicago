if @user
  json.id @user.id
  json.role @user.role
  json.neighborhood_id @user.neighborhood_id
  json.organizations @orgs
end
