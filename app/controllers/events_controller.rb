class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    #Hard coding the location
    @user_location = [35.6449777, 139.7139662]
    time = DateTime.new(2024, 3, 8, 4, 0, 0)
    @events_all = Event.where("end_at > ?", time)
    @events = Event.where("end_at > ?", time).near(@user_location, 9, unit: :km)
    # @events = Event.where("end_at > ?", Time.now)
    @past_events = Event.where("end_at < ?", time)
    @checkin = Checkin.new
    @markers = @events_all.geocoded.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude,
        id: event.id,
        category: event.category,
        info_window_html: render_to_string(partial: "events/info_window", locals: {event: event}, formats: [:html]),
        checkin_count: event.checkins.count
      }
    end

    # @followee_markers = []

    # @followee_markers = current_user.followees.each do |followee|
    #   event = followee.current_attending_event
    #   next if event.geocoded?
    #   @followee_markers << {
    #     lat: event.latitude,
    #     lng: event.longitude,
    #     id: event.id,
    #     category: event.category,
    #     info_window_html: render_to_string(partial: "events/info_window", locals: {event: event}, formats: [:html]),
    #     marker_html: render_to_string(partial: "shared/user_avatar", locals: {user: followee}, formats: [:html]),
    #     checkin_count: event.checkins.count
    #   }
    # end if user_signed_in?

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

    # respond_to do |format|
    #   format.html
    #   format.text
    # end
  end

  def dashboard
    @user = current_user
    checkins = @user.checkins
    past_events = []
    checkins.each do |checkin|
      if checkin.event.end_at < Time.now
        past_events << checkin.event
      end
    end
    @events = past_events
  end

  def details
    @event = Event.find(params[:id])
    @comments = @event.comments
    @comment = Comment.new
    @user = current_user
    badges_sashes = @user.sash&.badges_sashes.where(created_at: (10.seconds.ago..Time.now))
    unless badges_sashes.empty? || badges_sashes.nil?
      flash.now[:notice] = "You earned a badge!"
      @badge_image = badges_sashes.first.badge.custom_fields[:image]
      @badge_name = badges_sashes.first.badge.custom_fields[:title]
    end
  end

  def follows
    @user = current_user
    # @user_all = User.all
    @followees = @user.favorited_by_type('User')
    # @followers = @user.user_favoritors
  end

  def friends
    @current_user = current_user
    @users = User.all

    if params[:query].present?
      @users = @users.where("username ILIKE ?", "%#{params[:query]}%")
    end

    respond_to do |format|
      format.html
      format.text { render partial: "friends_list", locals: { users: @users }, formats: [:html] }
    end
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
      if current_user.unfavorite(user)
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
