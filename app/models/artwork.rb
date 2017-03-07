class Artwork < ApplicationRecord
  validates :title, presence: true
  validates :artist, presence: true
  validates :description, presence: true
  validates :address, presence: true
  enum status: %w(pending approved rejected)

  belongs_to :user
  belongs_to :neighborhood
end
