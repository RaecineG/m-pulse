class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @events = Event.all
    @markers = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude,
        id: event.id,
        info_window_html: render_to_string(partial: "info_window", locals: {event: event})
      }
    end
    recommended
  end

  def show
    @event = Event.find(params[:id])
    @user = current_user
    @checkin = Checkin.new
    @marker = {
      lat: @event.latitude,
      lng: @event.longitude
    }
    @checkin.user = @user
    @checkin.event = @event
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def recommended
    # @user_coordinates = [request.location.latitude, request.location.longitude]
    @user_coordinates = [35.6537872, 139.6928169]
    @events = Event.all
    @locations = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
    @events_near = Event.near(@user_coordinates, 50)
  end

  def dashboard
    @user = current_user
    @events = @user.events
  end

  def details
    @event = Event.find(params[:id])
    @comments = @event.comments
    @comment = Comment.new
    @user = current_user
  end

  private

  def event_params
    params.require(:event).permit(:name, :address, :description, :start_at, :end_at, :category, :photo)
  end
end
