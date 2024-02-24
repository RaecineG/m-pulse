class CheckinsController < ApplicationController
  def index
  end

  def create
    @event = Event.find(params[:event_id])
    @user = current_user
    @checkin = Checkin.new
    @checkin.user = @user
    @checkin.event = @event
    if @checkin.save
      redirect_to events_path # replace with events page for commenting
    else
      render event_path(@event), status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def checkin_params
    params.require(:checkin).permit(:status)
  end
end
