class CommentsController < ApplicationController
  def index
  end

  def create
    @comment = Comment.new(contents)
    @event = Event.find(params[:event_id])
    @user = current_user
    @comment.user = @user
    @comment.event = @event
    if checked_in?(@event, @user)
      @comment.save
      EventChannel.broadcast_to(
        @event,
        render_to_string(partial: "info_window", locals: {comment: @comment})
        
      )
      head :ok

      redirect_to details_path(@event)
    else
      flash.alert = "You need to be checked in to this event!"
      redirect_to details_path(@event), status: :unprocessable_entity
    end
  end

  private

  def contents
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
