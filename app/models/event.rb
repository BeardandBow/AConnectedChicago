class Event < ApplicationRecord
  validates :title, presence: true
  validates :host_contact, presence: true
  validates_format_of :host_contact, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create, message: "please use a valid email for the host."
  validates :description, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :address, presence: true
  enum status: %w(pending approved rejected)
end
