class Neighborhood < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
