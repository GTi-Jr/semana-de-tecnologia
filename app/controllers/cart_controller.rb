class CartController < ProfileController
  def show
    @cart_events = @user.events
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments
    @number = 0
    @payment = Payment.new
    @time = Time.now
    @package = @user.package
    @user_cart = @user.events_kind_count
    @cart_total = Event.cart_total_price(@user)
  end

  def create
    @cart_events = @user.events
    @total_price = Event.cart_total_price(@user)

    @payment = Payment.new(user_id: current_user.id)
    @payment.method = payment_params[:method]
    @payment.price = @total_price

    if !@cart_events.empty?
      case payment_params[:method]
      when @payment.accepted_payment_methods[0]

        result = Payment.transaction do
          @pag = pag_seguro(@total_price, @user)
          @payment.save
        end

        if result
          redirect_to @pag.url
        else
          redirect_to cart_path, notice: "Erro ao efetuar pagamento! #{@payment.errors.full_messages.first}"
        end
      when @payment.accepted_payment_methods[1], @payment.accepted_payment_methods[2]
        if @payment.save
          PaymentMailer.new_payment(@user, @payment).deliver_now
          PaymentMailer.info(@user, @payment, current_week[:infos]).deliver_now
          redirect_to :my_home, notice: 'Compra finalizada com sucesso! Verifique a informações para efetuar o pagamento.'
        else
          redirect_to cart_path, notice: "Erro ao efetuar pagamento! #{@payment.errors.full_messages.first}"
        end
      when @payment.accepted_payment_methods[3]
        if @payment.save
          PaymentMailer.new_payment(@user, @payment).deliver_now
          PaymentMailer.info(@user, @payment, current_week[:infos]).deliver_now
          redirect_to :my_home, notice: "Compra finalizada com sucesso! Verifique a informações para efetuar o pagamento."
        else
          redirect_to cart_path, notice: "Erro ao efetuar pagamento! #{@payment.errors.full_messages.first}"
        end
      end
      @payment.pending
    else
      redirect_to cart_path, notice: 'Erro ao efetuar pagamento! Seu carrinho está vazio!'
    end
  end

  def require_change_payment
    if PaymentMailer.require_change(@user).deliver_now
      redirect_to :cart, notice: 'Sua solicitação foi enviada, aguarde contato!'
    end
  end

  def add
    @purchase = Purchase.new(buyer_id: @user.id, event_id: params[:id])
    if @purchase.save
      redirect_to :back
    else
      redirect_to :back, notice: @purchase.errors.full_messages.first || 'Não há mais vagas disponíveis para este evento'
    end
  end

  def remove
    Purchase.delete_purchases(current_user, params[:id])

    redirect_to :back
  end

  private

  def current_user_cart
    "cart#{current_user.id}"
  end

  def pag_seguro(value, user)
    # O modo como você irá armazenar os produtos que estão sendo comprados
    # depende de você. Neste caso, temos um modelo Order que referência os
    # produtos que estão sendo comprados.
    order = user.id
    @cart = user.get_cart_events

    #payment = PagSeguro::PaymentRequest.new

    # Você também pode fazer o request de pagamento usando credenciais
    # diferentes, como no exemplo abaixo

    payment = PagSeguro::PaymentRequest.new

    payment.reference = order
    #payment.notification_url = notifications_url
    payment.redirect_url = cart_url
    payment.sender = {
      email: user.email
    }
    # @cart.each do |product|
    payment.items << {
      id: user.id,
      description: user.package ? "Pacote #{user.package.title}" : 'Compra fora do pacote',
      amount: value.to_f
    }
    # end

    response = payment.register
  end

  def payment_params
    params.require(:payment).permit(:method)
  end
end
