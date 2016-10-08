class PackagesController < ProfileController
  before_action :user_have_a_payment
  before_action :set_package, only: [:add_package]

  def index
    @packages = Package.all
    @package_1 = Package.first
    @user = current_user
  end

  def add_package
    if @user.package
      @user.inscription.update_attribute(:package_id, @package.id)
      redirect_to :my_home, notice: 'Pacote escolhido com sucesso!'
    else
      @inscription = Inscription.new(user: @user, package: @package)
      if @inscription.save
        redirect_to :my_home, notice: 'Pacote escolhido com sucesso!'
      else
        redirect_to :packages, notice: @inscription.errors.full_messages.first
      end
    end
  end

  def remove_package
    if @user.inscription.destroy
      redirect_to :my_home, notice: 'Pacote removido com sucesso!'
    else
      redirect_to :packages
    end
  end

  protected

  def set_package
    @package = Package.find(params[:package_id])
  end

  def user_have_a_payment
    if @user.payment
      redirect_to :cart, notice: 'Você não pode adicionar um pacote com um pagamento pendente.'
    end
  end
end
