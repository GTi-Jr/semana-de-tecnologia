class Challenge::MemberController < ApplicationController
  layout 'devise'
  before_action :set_challenge_team

  def new_inscription
    @members = []
    @errors = []
    @challenge_team.limit.times do |i|
      @members << Challenge::Member.new
    end
  end

  def create_inscription
    @members = params.require(:members)
    @errors = []
    @members.each do |index, member|
      @member = @challenge_team.challenge_members.new(member.permit(:name, :email))
      if !@member.save
        @errors << @member.errors
      end
    end

    if @errors.empty?
      ChallengeMailer.inscription(@challenge_team).deliver_now
      ChallengeMailer.info(@challenge_team, current_week[:infos]).deliver_now
      redirect_to :challenge_new_team_inscription, notice: 'Equipe cadastrada con sucesso, você recebera as instruções por email!'
    else
      render :new_inscription, notice: 'Erro ao cadastrar equipe!'
    end
  end

  protected
  def set_challenge_team
    @challenge_team = Challenge::Team.find(params[:team_id])
    if !@challenge_team.challenge_members.empty?
      redirect_to challenge_new_team_inscription_path, notice: 'Time já possui membros cadastrados, tente criar outro time!'
    end
  end

end
