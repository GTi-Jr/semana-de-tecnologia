class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/1
  def show
    @event_users = @event.buyers
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to [:admin, @event], notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to [:admin, @event], notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    if @event.destroy
      redirect_to admin_events_url, notice: 'Event was successfully destroyed.'
      
    else
      redirect_to admin_events_url, notice: @event.errors.full_messages[0]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:name, :description, :facilitator, :limit, :price, :event_type_id)
    end



    def erase_event_cart(event_id)
      users = User.all 
      users.each do |user|
      $redis.srem "cart#{user.id}", event_id

    end
  end

end
