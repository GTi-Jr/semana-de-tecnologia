class Admin::CommentsController < Admin::BaseController
  include ApplicationHelper
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  # GET /events
  def index
    @comments = Comment.all
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @comment = Comment.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      User.all.each do |user|
        NoticesMailer.send_notification(user, @comment, current_week).deliver_now
      end
      redirect_to [:admin, @comment], notice: 'comment was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @comment.update(comment_params)
      redirect_to [:admin, @comment], notice: 'comment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @comment.destroy
    redirect_to admin_comments_url, notice: 'comment was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:title, :description)
    end
end
