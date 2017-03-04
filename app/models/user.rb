class User < ApplicationRecord
  validates :email, presence: true
  has_secure_password
  enum role: %w(user community_leader admin)
end
