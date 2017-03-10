class SubmissionsController < ApplicationController

  def index
    @submissions = get_submissions
  end

  def update
    submissions = get_submissions
    params[:pkeys].each do |pkey|
      if params[pkey] == "approved"
        submission = submissions.find { |submission| submission.pkey == pkey }
        submission ? submission.approve : flash[submission.pkey] = "'#{submission.title}' has already been approved or denied"
      elsif params[pkey] == "denied"
        submission = submissions.find { |submission| submission.pkey == pkey }
        submission ? submission.reject : flash[submission.pkey] = "'#{submission.title}' has already been approved or denied"
      end
    end
    redirect_to submissions_path
  end

  private

  def get_submissions
    submissions = []
    events = Event.where(status: "pending", organization: current_user.organizations)
    submissions << events if events
    artworks = Artwork.where(status: "pending")
    if artworks
      submissions << artworks.find_all do |artwork|
        current_user.organizations.include(artwork.organization) if artwork.organization
      end
      submissions << artworks.find_all do |artwork|
        current_user.neighborhood == artwork.neighborhood && !artwork.organization
      end
    end
    stories = Story.where(status: "pending")
    if stories
      submissions << stories.find_all do |story|
        current_user.organizations.include(story.organization) if story.organization
      end
      submissions << stories.find_all do |story|
        current_user.neighborhood == story.neighborhood && !story.organization
      end
    end

    unless submissions.empty?
      submissions.flatten.sort_by do |submission|
        submission.created_at if submission
      end
    end
  end
end
