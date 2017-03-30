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
    submissions << Artwork.joins(:organization).where(organization_id: current_user.organizations, status: "pending")
    submissions << Artwork.joins(:neighborhood).where(neighborhood_id: current_user.neighborhood, status: "pending")

    submissions << Story.joins(:organization).where(organization_id: current_user.organizations, status: "pending")
    submissions << Story.joins(:neighborhood).where(neighborhood_id: current_user.neighborhood, status: "pending")

    unless submissions.empty?
      submissions.flatten.uniq.sort_by do |submission|
        submission.created_at if submission
      end
    end
  end
end
