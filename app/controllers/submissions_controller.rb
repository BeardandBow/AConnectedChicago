class SubmissionsController < ApplicationController

  def index
    @submissions = get_submissions
  end

  def update
    submissions = get_submissions
    params[:pkeys].each do |pkey|
      if params[pkey] == "approved"
        submissions.find { |submission| submission.pkey == pkey }
        .approve
      elsif params[pkey] == "denied"
        submissions.find { |submission| submission.pkey == pkey }
        .deny
      end
    end
    redirect_to submissions_path
  end

  private

  def get_submissions
    events = Event.find_by(status: "pending")
    artworks = Artwork.find_by(status: "pending")
    stories = Story.find_by(status: "pending")

    submissions = [events, artworks, stories].flatten.sort_by { |submission| submission.created_at }
  end
end
