class Admin::PackagesController < Admin::BaseController
  before_action :set_package, only: [:show, :edit, :update, :destroy]

  # GET /packages
  def index
    @packages = Package.all
  end

  # GET /packages/1
  def show
    @package_users = @package.users
    @package_event_type = PackageEventType.new
  end

  # GET /packages/new
  def new
    @package = Package.new
  end

  # GET /packages/1/edit
  def edit
  end

  # POST /packages
  def create
    @package = Package.new(package_params)

    if @package.save
      redirect_to [:admin, @package], notice: 'Package was successfully created.'
    else
      render :new, notice: @package.errors.full_messages[0]
    end
  end

  # PATCH/PUT /packages/1
  def update
    if @package.update(package_params)
      redirect_to [:admin, @package], notice: 'Package was successfully updated.'
    else
      render :edit, notice: @package.errors.full_messages[0]
    end
  end

  # DELETE /packages/1
  def destroy
    if @package.destroy
      redirect_to admin_packages_path, notice: 'Package was successfully destroyed.'
    else
      redirect_to admin_packages_path, notice: @package.errors.full_messages[0]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:id])
    end

    def package_params
      params.require(:package).permit(:title, :description, :limit, :price)
    end

    def package_event_type_params
      params.require(:package_event_type).permit(:event_type_id, :limit)
    end
end
