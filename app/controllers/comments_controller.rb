class CommentsController < ApplicationController
  def index
  end

  def create
    @comment = Comment.new(contents)
    @event = Event.find(params[:event_id])
    @user = current_user
    @comment.user = @user
    @comment.event = @event
    if @comment.save
      redirect_to details_path(@event)
    else
      redirect_to details_path(@event), status: :unprocessable_entity
    end
  end

  private

  def contents
    params.require(:comment).permit(:content)
  end
end
