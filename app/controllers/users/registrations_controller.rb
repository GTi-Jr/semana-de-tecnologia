class Users::RegistrationsController < Devise::RegistrationsController
  
  layout 'devise_layout'
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :set_current_week
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    @user = @current_week.users.new(sign_up_params)
    if @user.save
      if @user.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(:user, @user)
        respond_with @user, location: authenticated_user_root_path
      else
        set_flash_message! :notice, :"signed_up_but_#{@user.inactive_message}"
        expire_data_after_sign_in!
        respond_with @user, location: after_inactive_sign_up_path_for(@user)
      end
    else
      clean_up_passwords @user
      set_minimum_password_length
      respond_with @user
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :course, :semester, :birthday, :university])
  end

  def set_current_week
    @current_week = Week.find_by(subdomain: Apartment::Tenant.current)
  end
end