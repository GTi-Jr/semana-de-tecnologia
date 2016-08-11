class ProfilesController < ApplicationController
	before_action :authenticate_user!
	layout 'profile_layout'

	
  def index
  	@user = current_user
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments

   

    #@cart_action = @eventCart.cart_action current_user.try :id
   
  end

  def week 
    @user = current_user
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments
  end 

end
