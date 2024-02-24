class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # include Geocoder::IP
  # include Geocoder::ControllerHelpers
  def after_sign_out_path_for(resource_or_scope)
    root_path # or any other path
  end
end
