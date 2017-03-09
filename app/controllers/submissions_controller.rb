class SubmissionsController < ApplicationController

  def index
    events = Event.find_by(status: "pending")
    artworks = Artwork.find_by(status: "pending")
    stories = Story.find_by(status: "pending")
    @submissions = [events, artworks, stories]
      .flatten
      .sort_by { |submission| submission.created_at }
  end
end
