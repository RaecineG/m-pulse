class CheckinsController < ApplicationController
  def index
    @user = current_user

  end

  def create
    @event = Event.find(params[:event_id])
    @user = current_user
    @checkin = Checkin.new
    @checkin.user = @user
    @checkin.event = @event
    if @checkin.save
      redirect_to details_path(@event)
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
