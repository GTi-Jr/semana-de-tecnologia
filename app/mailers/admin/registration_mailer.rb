class Admin::RegistrationMailer < ApplicationMailer
  default from: Rails.application.secrets.sender_email

  def welcome(user, generated_password)
    @user = user
    @password = generated_password
    mail(to: @user.email, subject: 'Sua conta foi criada, verifique sua senha e troque-a.')
  end
end
