class Admin::SubmissionsController < ApplicationController

  def index
    @submissions = get_all_submissions
  end

  def show
    @submissions = get_unowned_submissions
  end

  def update
    if request.env["HTTP_REFERER"].include?("unowned")
      submissions = get_unowned_submissions
    else
      submissions = get_all_submissions
    end
    params[:pkeys].each do |pkey|
      if params[pkey] == "approved"
        submission = submissions.find { |submission| submission.pkey == pkey }
        submission ? submission.approve : flash[submission.pkey] = "'#{submission.title}' has already been approved or denied"
      elsif params[pkey] == "denied"
        submission = submissions.find { |submission| submission.pkey == pkey }
        submission ? submission.reject : flash[submission.pkey] = "'#{submission.title}' has already been approved or denied"
      end
    end
    redirect_to admin_submissions_path
  end

  private

  def get_unowned_submissions
    submissions = []
    # find events whose organizations have no community_leaders and have a status of pending
    events = Event.joins(organization: [:users]).where.not(organization: { users: {role: "community_leader"}}).where(status: "pending")
    submissions << events unless events.empty?

    pending_artworks = Artwork.where(organization_id: nil, status: "pending")
    artworks_without_community_leaders = Artwork.joins(organization: [:users]).where.not(organization: { users: {role: "community_leader"}}).where(status: "pending")
    pending_artworks << artworks_without_community_leaders unless artworks_without_community_leaders.empty?
    submissions << pending_artworks unless pending_artworks.empty?

    pending_stories = Story.where(organization_id: nil, status: "pending")
    stories_without_community_leaders = Story.joins(organization: [:users]).where.not(organization: { users: {role: "community_leader"}}).where(status: "pending")
    pending_stories << stories_without_community_leaders unless stories_without_community_leaders.empty?
    submissions << pending_stories unless pending_stories.empty?
    
    unless submissions.empty?
      submissions = submissions.flatten.sort_by do |submission|
        submission.created_at if submission
      end
    end
    submissions.each do |submission|
      users = User.where(neighborhood_id: submission.neighborhood_id, role: "community_leader")
      submissions.delete(submission) unless users.empty?
    end
    submissions
  end

  def get_all_submissions
    submissions = []
    events = Event.where(status: "pending")
    submissions << events if events
    artworks = Artwork.where(status: "pending")
    submissions << artworks if artworks
    stories = Story.where(status: "pending")
    submissions << stories if stories

    unless submissions.empty?
      submissions.flatten.sort_by do |submission|
        submission.created_at if submission
      end
    end
  end
end
