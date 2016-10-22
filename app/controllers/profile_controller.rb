class ProfileController < ApplicationController
	before_action :authenticate_user!, :get_user, :check_package
	layout 'profile_layout'

  def home
    @user_package = @user.package
    @comments = Comment.all
  end

  def verify_cart_count
    package = @user.package
    count = Event.event_kind_count(current_user)
    if package && !package.package_fit?(current_user)
           flash[:notice] = "ATENÇÃO: seu pacote não está completo!"
    end
  end

  private

  def get_user
    @user = current_user
  end

  def check_package
    if @user.package.nil? && !(['packages', 'profile'].include? controller_path)
      redirect_to packages_path, notice: 'Primeiro, você deve escolher um pacote.'
    end
  end
end
