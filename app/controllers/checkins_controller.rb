class CheckinsController < ApplicationController
  def index
  end

  def create
    # @user = current_user
    # @checkin = Checkin.new
    # @event = Event.find(params[:id])
    # @checkin.user = @user
    # @checkin.event = @event
    # @checkin.save

    # if @checkin.save
    #   redirect_to events_path
    # else
    #   render 'new', status: :unprocessable_entity
    # end
  end

  def destroy
  end

  private

  def checkin_params
    params.require(:checkin).permit(:status)
  end
end
