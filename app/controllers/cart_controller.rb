class CartController < ProfileController
  before_action :verify_cart_count, only: [:create]
  def show
    cart_ids = $redis.smembers current_user_cart
    @cart_events = Event.find(cart_ids)
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments
    @number = 0
    @payment = Payment.new
    @time = Time.now
    @package = @user.package
    @user_cart = @package.event_kind_count(current_user)
    @cart_total = @package.cart_total_price(current_user)
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
    @payment = Payment.new(user_id: current_user.id)
    @payment.method = payment_params[:method]
    @cart_events = Event.find(cart_ids)
    @total_price = @user.package.cart_total_price(@user)

    if !@cart_events.empty?
      case payment_params[:method]
      when 'Depósito bancário'
        if @payment.save

          redirect_to :my_home, notice: 'Compra finalizada com sucesso! Verifique a informações para efetuar o pagamento.'
        else
          render 'show', notice: 'Erro ao efetuar pagamento!'
        end
      when 'Em espécie(presencial)'
        if @payment.save

          redirect_to :my_home, notice: 'Compra finalizada com sucesso! Verifique a informações para efetuar o pagamento.'
        else
          render 'show', notice: 'Erro ao efetuar pagamento!'
        end
      when 'PagSeguro'
        @pag = pag_seguro(@total_price, @user)
        if @pag.errors.empty? && @payment.save

          redirect_to @pag.url
        else
          render 'show', notice: "Erro ao efetuar pagamento! #{pag.errors}"
        end
      end
    else
      render 'show', notice: 'Seu carrinho está vazio!'
    end
  end

  def add
    if Purchase.create(buyer_id: @user.id, event_id: params[:id])
      $redis.sadd current_user_cart, params[:id]
      redirect_to :back
    else
      redirect_to :back, notice:'Não há mais vagas disponíveis para este evento'
    end
  end

  def remove
    $redis.srem current_user_cart, params[:id]
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
      description: "Pacote #{user.package.title}",
      amount: value.to_f
    }
    # end
    response = payment.register
  end

  def payment_params
    params.require(:payment).permit(:method)
  end
end