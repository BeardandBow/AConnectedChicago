class Story < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
  validates :address, presence: true

  enum status: %w(pending approved rejected)

  mount_uploader :image, ImageUploader

  geocoded_by :address, latitude: :map_lat, longitude: :map_long
  before_validation :geocode
  before_validation :find_neighborhood
  before_create :format_embedded_youtube_link
  after_create :set_pkey

  belongs_to :user, optional: false
  belongs_to :neighborhood, optional: true
  belongs_to :organization, optional: true

  def path
    "/stories/#{self.id}"
  end

  def submission_type
    "story"
  end

  def set_pkey
    self.update_attributes(pkey: "ST-#{self.id}")
  end

  def approve
    self.update_attributes(status: "approved")
  end

  def reject
    self.update_attributes(status: "rejected")
  end

  def formatted_update_time
    self.updated_at.strftime("%m/%d/%Y %I:%M %p")
  end

  def formatted_create_time
    self.created_at.strftime("%m/%d/%Y %I:%M %p")
  end

  def deletable_by?(current_user)
    if current_user
      if self.user == current_user
        true
      elsif current_user.role == "community_leader" && current_user.organizations.include?(self.organization)
        true
      elsif current_user.role == "community_leader" && current_user.neighborhood == self.neighborhood
        true
      elsif current_user.role == "admin"
        true
      end
    end
  end

  private

    def find_neighborhood
      hoods = Neighborhood.all
      neighborhood = hoods.find do |hood|
        hood.has?(self.map_lat.to_f, self.map_long.to_f)
      end
      self.assign_attributes(neighborhood: neighborhood)
    end

    def format_embedded_youtube_link
      if self.youtube_link.empty?
        self.assign_attributes(youtube_link: nil)
      else
        youtube_id = self.youtube_link.split('=').last
        self.assign_attributes(youtube_link: "https://www.youtube.com/embed/#{youtube_id}")
      end
    end
end
