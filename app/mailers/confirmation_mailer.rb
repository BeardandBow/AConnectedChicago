class ConfirmationMailer < ApplicationMailer

  def send_confirmation(user)
    @user = user
    mail(to: "#{user.email}", subject: "Email confirmation for A Connected Chicago")
  end
end
