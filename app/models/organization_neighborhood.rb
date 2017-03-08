class OrganizationNeighborhood < ApplicationRecord
  belongs_to :neighborhood
  belongs_to :organization
end
