class ProfileController < ApplicationController
	before_action :authenticate_user!, :get_user
	layout 'profile_layout'
  

  def home
    @user_package = @user.package
    @comments = Comment.all
  end

  def get_user
    @user = current_user
  end





  def create_inscription_preWeek
      event = params[:event]
      
     
      PreWeek.inscription(@user,event).deliver_now
      redirect_to :back

  end

  def cancel_inscription_preWeek
      event = params[:event]
      
      
      PreWeek.cancel_inscription(@user,event).deliver_now
      redirect_to :back
  end

end
