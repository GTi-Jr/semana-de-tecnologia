class CartsController < ApplicationController
  before_action :authenticate_user!
  layout 'profile_layout'




  def show
    cart_ids = $redis.smembers current_user_cart
    @cart_events = Event.find(cart_ids)
    @user = current_user
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments
    @number = 0

    

   
  end

  def new
    cart_ids = $redis.smembers current_user_cart
    @cart_events = Event.find(cart_ids)
    @user = current_user
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments
    @number = 0


    @payment = Payment.new
  end 


  def create
    method = params[:method]
     @payment = Payment.new(method:method, user_id:current_user.id)    # Not the final implementation!
    if @payment.save
      # Handle a successful save.
      redirect_to  user_dashboard_path
    else
      render 'new'
    end
  end


  def add
    
    $redis.sadd current_user_cart, params[:id]

   # respond_to do |format|
    #  format.js {render json: current_user.cart_count,  status: 200}
    #end 
    redirect_to :back
  end

  def remove
    $redis.srem current_user_cart, params[:id]
  
    #respond_to do |format|

     # format.js {render json: current_user.cart_count , status: 200}
    #end 
    redirect_to :back
  end

  private

  def current_user_cart
    "cart#{current_user.id}"
  end
end