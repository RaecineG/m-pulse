class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @events = Event.all
    @markers = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
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
    @checkin.save
    # if @checkin.save
    #   render action: "checkins/create"
    # else
    #   render 'index', status: :unprocessable_entity
    # end
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
    @events_near = Event.near(@user_coordinates, 10)
  end
end
