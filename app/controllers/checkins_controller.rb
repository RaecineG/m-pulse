class CheckinsController < ApplicationController
  def index
  end

  def create
    @event = Event.find(params[:id])
    @checkin = Checkin.new(checkin_params)
    @checkin.user = @user
    @checkin.event = @event
    raise
    if @checkin.save
      redirect_to events_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def checkin_params
    params.require(:checkin).permit(:status)
  end
end
