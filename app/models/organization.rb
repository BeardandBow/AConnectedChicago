class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :type
  has_many :events
  has_many :stories
  has_many :artworks
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :locations, reject_if: proc { |attributes| :all_blank || Location.where(address: attributes['address']).first.present? },
                                            allow_destroy: true
  has_many :organization_neighborhoods
  has_many :neighborhoods, through: :organization_neighborhoods
  has_many :organization_users
  has_many :users, through: :organization_users

  before_create :strip_name


  private

    def strip_name
      self.name = self.name.strip
    end
end
