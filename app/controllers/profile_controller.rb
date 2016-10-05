class ProfileController < ApplicationController
	before_action :authenticate_user!, :get_user
	layout 'profile_layout'

  def home
    @user_package = @user.package
    @comments = Comment.all
  end

  def verify_cart_count
    package = @user.package
    count = Event.event_kind_count(current_user)
    if package && !package.package_fit?(current_user)
           redirect_to :events, notice:"seu pacote não está completo."

  end

  def get_user
    @user = current_user
  end
end
