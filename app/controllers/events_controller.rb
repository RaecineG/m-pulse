class EventsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def recommended
    # user_coordinates = [request.location.latitude, request.location.longitude]
    @user_coordinates = [35.661777, 139.704051]
    @events = Event.all
    @locations = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
    @events_near = Event.near(@user_coordinates, 100)
  end
end
