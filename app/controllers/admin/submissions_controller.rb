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
    if request.env["HTTP_REFERER"].include?("unowned")
      redirect_to admin_unowned_submissions_path
    else
      redirect_to admin_submissions_path
    end
  end

  private

  def get_unowned_submissions
    submissions = []
    # find events whose organizations have no community_leaders and have a status of pending
    events_without_hood_users = Event.joins(:neighborhood).find_all { |e| e.neighborhood.users.empty? && s.status === "pending"}

    events = Event.joins(organization: [:users])
            .where.not(organization: { users: {role: "community_leader"}})
            .joins(neighborhood: [:users])
            .where.not(neighborhood: { users: {role: "community_leader"}})
            .where(status: "pending")

    submissions << events unless events.empty?
    submissions << events_without_hood_users unless events_without_hood_users.empty?

    pending_artworks = Artwork.where(organization_id: nil, status: "pending").to_a
    art_without_org_users = Artwork.joins(:organization).find_all { |a| a.organization.users.empty? && s.status === "pending"}
    art_without_hood_users = Artwork.joins(:neighborhood).find_all { |a| a.neighborhood.users.empty? && s.status === "pending"}

    pending_artworks << art_without_org_users unless art_without_org_users.empty?
    pending_artworks << art_without_hood_users unless art_without_hood_users.empty?

    artworks_without_community_leaders = Artwork.joins(organization: [:users])
                                        .where.not(organization: { users: {role: "community_leader"}})
                                        .joins(neighborhood: [:users])
                                        .where.not(neighborhood: { users: {role: "community_leader"}})
                                        .where(status: "pending")

    pending_artworks << artworks_without_community_leaders unless artworks_without_community_leaders.empty?
    submissions << pending_artworks unless pending_artworks.empty?

    pending_stories = Story.where(organization_id: nil, status: "pending").to_a
    stories_without_org_users = Story.joins(:organization).find_all { |s| s.organization.users.empty? && s.status === "pending"}
    stories_without_hood_users = Story.joins(:neighborhood).find_all { |s| s.neighborhood.users.empty? && s.status === "pending"}

    pending_stories << stories_without_org_users unless stories_without_org_users.empty?
    pending_stories << stories_without_hood_users unless stories_without_hood_users.empty?

    stories_without_community_leaders = Story.joins(organization: [:users])
                                        .where.not(organization: { users: {role: "community_leader"}})
                                        .joins(neighborhood: [:users])
                                        .where.not(neighborhood: { users: {role: "community_leader"}})
                                        .where(status: "pending")

    pending_stories << stories_without_community_leaders unless stories_without_community_leaders.empty?
    submissions << pending_stories unless pending_stories.empty?

    unless submissions.empty?
      submissions = submissions.flatten.uniq.sort_by do |submission|
        submission.created_at if submission
      end
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
