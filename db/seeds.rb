require 'factory_girl_rails'
require './spec/support/factories'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

class Seed
  def self.start
    hood = FactoryGirl.create(:neighborhood)
    FactoryGirl.create(:user, :community_leader)
    FactoryGirl.create(:story, neighborhood_id: hood.id)
    FactoryGirl.create(:event, neighborhood_id: hood.id)
    FactoryGirl.create(:artwork, neighborhood_id: hood.id)
  end
end

Seed.start
