class ApplicationController < ActionController::Base
  before_action :configure_permitted_params, if: :devise_controller?

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[fullname phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[fullname phone_number description])
  end
end
