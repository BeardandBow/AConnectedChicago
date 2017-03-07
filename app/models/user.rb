class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "please use a valid email address."
  has_secure_password
  enum role: %w(user community_leader admin)

  has_many :artworks
  has_many :events
  has_many :stories
end
