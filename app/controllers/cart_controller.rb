class CartController < ProfileController
  before_action :verify_cart_count, only: [:create]
  def show
    @cart_events = @user.events
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments
    @number = 0
    @payment = Payment.new
    @time = Time.now
    @package = @user.package
    @user_cart = Event.event_kind_count(current_user)
    @cart_total = Event.cart_total_price(current_user)
  end

  def new
    cart_ids = $redis.smembers current_user_cart
    @cart_events = Event.find(cart_ids)
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments
    @number = 0
  end


  def create
    cart_ids = $redis.smembers current_user_cart
    @cart_events = Event.find(cart_ids)
    @total_price = Event.cart_total_price(@user)

    @payment = Payment.new(user_id: current_user.id)
    @payment.method = payment_params[:method]
    @payment.price = @total_price

    if !@cart_events.empty?
      case payment_params[:method]
      when @payment.accepted_payment_methods[0]
        @pag = pag_seguro(@total_price, @user)
        byebug

        if @pag.errors.empty? && @payment.save
          redirect_to @pag.url
        else
          render 'show', notice: "Erro ao efetuar pagamento! #{@pag.errors}"
        end
      when @payment.accepted_payment_methods[1], @payment.accepted_payment_methods[2]
        if @payment.save
          PaymentMailer.new_payment(@user, @payment).deliver_now
          PaymentMailer.info(@user, @payment, current_week[:infos]).deliver_now
          redirect_to :my_home, notice: 'Compra finalizada com sucesso! Verifique a informações para efetuar o pagamento.'
        else
          render 'show', notice: 'Erro ao efetuar pagamento!'
        end
      when @payment.accepted_payment_methods[3]
        if @payment.save
          PaymentMailer.new_payment(@user, @payment).deliver_now
          PaymentMailer.info(@user, @payment, current_week[:infos]).deliver_now
          redirect_to :my_home, notice: 'Compra finalizada com sucesso! Verifique a informações para efetuar o pagamento.'
        else
          render 'show', notice: 'Erro ao efetuar pagamento!'
        end
      end
      @payment.pending
    else
      render :show, notice: 'Seu carrinho está vazio!'
    end
  end

  def require_change_payment
    if PaymentMailer.require_change(@user).deliver_now
      redirect_to :cart, notice: 'Sua solicitação foi enviada, aguarde contato!'
    end
  end

  def remove_payment
    payment = @user.payment
    if @user.payment.destroy
      PaymentMailer.require_cancel(@user, payment).deliver_now
      redirect_to :cart, notice: 'Compra cancelada com sucesso!'
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
    byebug
    response = payment.register
  end

  def payment_params
    params.require(:payment).permit(:method)
  end
end