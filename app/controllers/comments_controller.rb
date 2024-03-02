class CommentsController < ApplicationController
  def index
  end

  def create
    @comment = Comment.new(comment_params)
    @event = Event.find(params[:event_id])
    @user = current_user
    @comment.user = @user
    @comment.event = @event
    # if checked_in?(@event, @user)
    @comment.save
    EventChannel.broadcast_to(
      @event,
      render_to_string(partial: "comment", locals: {comment: @comment})
    )
    head :ok
    # else
      # flash.alert = "You need to be checked in to this event!"
    #   redirect_to details_path(@event), status: :unprocessable_entity
    # end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def checked_in?(event, user)
    checked_in_users = []
    event.checkins.each do |checkin|
      checked_in_users << checkin.user
    end
    checked_in_users.include?(user)
  end
end
