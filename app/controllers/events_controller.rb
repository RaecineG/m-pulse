class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @events = Event.all
    @checkin = Checkin.new
    @markers = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude,
        id: event.id,
        category: event.category,
        info_window_html: render_to_string(partial: "events/info_window", locals: {event: event}, formats: [:html]),
        checkin_count: event.checkins.count
      }
    end

    if params[:query].present?
      @events = @events.where("name ILIKE ?", "%#{params[:query]}%")
    end

   respond_to do |format|
     format.html
     format.text { render partial: "events/event_list", locals: { events: @events, coords: params[:coords] }, formats: [:html] }
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
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    photos = event_params[:photos]
    photos.each do |photo|
      next if photo.blank?

      @event.photos.attach(io:photo.tempfile, filename:photo.original_filename, content_type:photo.content_type)
    end
  end

  def destroy
  end

  def recommended

    @locations = @events.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude
      }
    end
    @events_near = Event.all
    @categories = @events_near.pluck(:category).uniq

    if params[:query].present?
       @events = @events.where("name ILIKE ?", "%#{params[:query]}%")
    end

    respond_to do |format|
      format.html
      format.text
    end
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

  def follows
    @user = current_user
    @user_all = User.all
    @follows = @user.all_favorites
    @followers = @user.user_favoritors
  end

  def friends
    @current_user = current_user
    @users = User.all
  end

  def follow_user
    user = User.find(params[:user_id])
    value = params[:follow]
    if value == "follow"
      if current_user.favorite(user)
        redirect_to friends_path
      else
        redirect_to friends_path
        flash.now[:alert] = "Sorry, alrady following"
      end
    else
      if curent_user.unfavorite(user)
        redirect_to friends_path
      else
        redirect_to friends_path
        flash.now[:alert] = "Sorry, couldnt unfollow."
      end
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :address, :description, :start_at, :end_at, :category, photos: [])
  end
end
