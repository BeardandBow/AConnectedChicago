class Type < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  enum category: %w(event organization)

  has_many :organizations
  has_many :events
end
