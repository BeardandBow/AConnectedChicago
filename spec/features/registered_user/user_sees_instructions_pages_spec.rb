require 'rails_helper'

RSpec.feature "user sees instructions pages" do
  before :each do
    @user = create(:user, :registered_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end
  scenario "user sees event instructions" do
    visit new_event_path

    click_link("here")

    expect(current_path).to eq(event_instructions_path)
    expect(page).to have_content("All Events uploaded MUST be linked with a Connected Chicago organization")
    expect(page).to have_content("The Brief Description of Event should be between 1-3 sentences")
    expect(page).to have_content("The Address used for Event MUST be a Complete Geographical Location")
    expect(page).to have_content("In the Event Website Link box, if applicable, include a Facebook Event link")
  end

  scenario "user sees story instructions" do
    visit new_story_path

    click_link("here")

    expect(current_path).to eq(story_instructions_path)
    expect(page).to have_content("Recommendation: Choose ONE of the following, either to submit your Story via Video OR submit your Written Story.")
    expect(page).to have_content("How to Upload Video: If your Story has a Video, first upload your Video to Youtube, and then insert the link to your video below. Your video link MUST be hosted on YouTube.")
    expect(page).to have_content("How to Upload Written Story: Insert your “Written Story” below. Stories can include personal anecdotes, reflections and/or poems.")
    expect(page).to have_content("The Author of Story can be an individual or collective authorship. You should own the rights to the video, or have been given permission by the organization to share.")
    expect(page).to have_content("Story MUST be linked to a Complete Geographical Address in order to appear on Connected Chicago Map")
    expect(page).to have_content("The “Brief Description of Story” should be limited to 1-3 sentences. This short description will appear under video and give synopsis to viewer about what the Story is about.")
    expect(page).to have_content("There is NO LIMIT on the amount of Stories you can submit.")
  end

  scenario "user sees artwork instructions" do
    visit new_artwork_path

    click_link("here")

    expect(current_path).to eq(artwork_instructions_path)
    expect(page).to have_content("The Name of Artist can be an individual, multiple artists or a collective authorship by organization or group. You should own the rights to personal artwork, or have been given permission by an organization to share. If it is Public Art, then you can submit the Public Artwork in the name of The City of Chicago or the Artist that created the artwork (if applicable)")

    expect(page).to have_content("The Brief Description of Artwork should be between 1-3 sentences (one paragraph MAX), describing the power or history of the artwork.")

    expect(page).to have_content("Artwork MUST be linked to a Complete Geographical Address in order to appear on Connected Chicago Map;")

    expect(page).to have_content("Note: A future version of this site will include the function of uploading art through music.")
  end
end
