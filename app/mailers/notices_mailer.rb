class NoticesMailer < ApplicationMailer
    def send_notification(user, notice, week)
      @user = user
      @notice = notice
      @week = week
      mail(to: @user.email, from: Rails.application.secrets.sender_email, subject: "A #{@week[:sigla]} cadastrou uma nova notícia")
    end

    

end
