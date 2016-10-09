class Admin::PackagesEventsTypesController < Admin::BaseController
  before_action :set_package
  before_action :set_package_event_type, only: [:destroy]

  # POST /packages
  def create
    @package_event_type = PackageEventType.new(package_event_type_params)
    @package_event_type.package_id = @package.id
    if @package_event_type.save
      redirect_to admin_package_path(@package), notice: 'Tipo de programação criado.'
    else
      redirect_to admin_package_path(@package), notice: @package_event_type.errors.full_messages[0]
    end
  end

  # DELETE /packages/1
  def destroy
    if @package_event_type.destroy
      redirect_to admin_packages_path, notice: 'Tipo de programação deletado.'
    else
      redirect_to admin_packages_path, notice: @package_event_type.errors.full_messages[0]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:package_id])
    end

    def set_package_event_type
      @package_event_type = PackageEventType.find(params[:id])
    end

    def package_event_type_params
      params.require(:package_event_type).permit(:event_type_id, :limit)
    end
end
