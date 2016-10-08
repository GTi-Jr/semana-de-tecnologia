class Admin::TeamsController < Admin::BaseController
  before_action :set_challenge_team, only: [:show, :edit, :update, :destroy, :confirm_payment]

  # GET /admin/users
  def index
    @admin_challenge_teams = Challenge::Team.all
  end

  # GET /admin/users/1
  def show
    @challenge_team_members = @challenge_team.challenge_members
  end

  # GET /admin/users/new
  def new
    @challenge_team = Challenge::Team.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  def create
    if @challenge_team.save
      redirect_to [:admin, @challenge_team], notice: 'Challenge::Team was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/users/1
  def update
    if @challenge_team.update(challenge_team_params)
      redirect_to [:admin, @challenge_team], notice: 'Challenge::Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/users/1
  def destroy
    @challenge_team.destroy
    redirect_to admin_challenge_teams_url, notice: 'Challenge::Team was successfully destroyed.'
  end

  # PATCH
  def confirm_payment
    if @challenge_team.update_attribute(:payment_status,true)
      ChallengeMailer.confirm_payment(@challenge_team).deliver_now
      redirect_to :admin_challenge_teams
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_challenge_team
      @challenge_team = Challenge::Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def challenge_team_params
      params.require(:challenge_team).permit(:name, :email, :payment_methods, :limit)
    end
end
