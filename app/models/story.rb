class Story < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
  validates :body, presence: true
  validates :address, presence: true
  enum status: %w(pending approved rejected)

  belongs_to :user
  belongs_to :neighborhood
end
