class Admin::UsersController < Admin::BaseController
  before_action :set_admin_user, only: [:show, :edit, :update, :destroy]

  # GET /admin/users
  def index
    @admin_users = User.all
  end

  # GET /admin/users/1
  def show
    @payment = @admin_user.payment
    @package = @admin_user.package
  end

  # GET /admin/users/new
  def new
    @admin_user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  def set_payment
    @admin_user = User.find(params[:user_id])
    if @admin_user.payment.update(method: params[:payment_method], status: params[:status])
      redirect_to admin_users_path, notice: 'Pagamento alterado com sucesso!'
    end
  end

  def remove_from_event
    @admin_user = User.find(params[:user_id])
    @event = Event.find(params[:id])
    if @admin_user.events.destroy(@event)
      render :show, notice: 'Usuário removido do evento!'
    end
  end

  def remove_from_all_events
    @admin_user = User.find(params[:user_id])
    if @admin_user.events.destroy_all
      render :show, notice: 'Usuário removido de todos os eventos!'
    end
  end

  # POST /admin/users
  def create
    @admin_user = User.new(admin_user_params)
    generated_password = Devise.friendly_token.first(8)
    @admin_user.password = generated_password
    if @admin_user.save
      Admin::RegistrationMailer.welcome(@admin_user, generated_password).deliver_now
      redirect_to [:admin, @admin_user], notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    if @admin_user.update(admin_user_params)
      redirect_to [:admin, @admin_user], notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/users/1
  def destroy
    @admin_user.destroy
    redirect_to admin_users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_user
      @admin_user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def admin_user_params
      params.require(:user).permit(:name, :email, :course, :semester, :birthday, :university)
    end
end
