class PaymentMailer < ApplicationMailer
  def require_change(user)
    @user = user
    mail(to: Rails.application.secrets.sender_email, from: @user.email, subject: 'Solicitação de mudança de pagamento')
  end

  def require_cancel(user,payment)
    @user = user
    @payment = payment
    mail(to: Rails.application.secrets.sender_email, from: @user.email, subject: 'Compra cancelada')
  end

  def new_payment(user,payment)
    @user = user
    @payment = payment
    mail(to: Rails.application.secrets.sender_email, from: @user.email, subject: 'Solicitação de compra')
  end

  def info(user,payment, infos)
    @user = user
    @payment = payment
    @infos = infos
    mail(to: @user.email, from: Rails.application.secrets.sender_email, subject: 'Informações de pagamento')
  end

  def status(user, payment)
    @user = user
    @payment = payment
    mail(to: @user.email, from: Rails.application.secrets.sender_email, subject: '[PAGAMENTO] Status alterado')
  end
end
