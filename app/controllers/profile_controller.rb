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
end
