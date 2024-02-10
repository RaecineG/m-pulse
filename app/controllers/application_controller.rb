class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # include Geocoder::IP
  # include Geocoder::ControllerHelpers
end
