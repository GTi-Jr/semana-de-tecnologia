module CartHelper

  def render_cart
    if current_user.is_there_payment?
      render :partial => 'cart/show_cart'
    else
      render :partial => 'cart/blocked_cart'
    end
  end

  def render_payment_form
    case current_user.payment.method
    when current_user.payment.accepted_payment_methods[0], current_user.payment.accepted_payment_methods[1]
      render :partial => 'cart/partial_show_deposito'
    when @payment.accepted_payment_methods[2]
      render :partial => 'cart/partial_show_presencial'
    end
  end
end
