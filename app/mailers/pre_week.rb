class PreWeek < ApplicationMailer
	 def inscription(user, event)
    @user = user
    mail(to: Rails.application.secrets.sender_email, from: @user.email, subject: 'Pré-semana Inscrição #{event}')
    
    $redis.sadd "cart#{@user.id}", event



  end

  def cancel_inscription(user, event)
  	@user = user
  	mail(to: Rails.application.secrets.sender_email, from: @user.email, subject: 'Pré-semana-Cancelamento #{event}')
    $redis.srem "cart#{@user.id}", event
  end


  

end
