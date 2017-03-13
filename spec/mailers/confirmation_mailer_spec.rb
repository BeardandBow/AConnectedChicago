require "rails_helper"

RSpec.describe ConfirmationMailer do
  describe "send_confirmation" do
    before :all do
      @user = create(:user)
      @email = ConfirmationMailer.send_confirmation(@user)
    end

    it "renders the subject" do
      expect(@email.subject).to eq("Email confirmation for A Connected Chicago")
    end

    it "renders the receiver email" do
      expect(@email.to).to eq([@user.email])
    end

    it "contains user name" do
      expect(@email.body.raw_source).to include(@user.first_name)
    end

    it "contains confirmation link" do
      expect(@email.body.raw_source).to include(confirm_user_email_url(@user.email_token))
    end
  end
end
