class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!, only: [:index]
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :group_key
    devise_parameter_sanitizer.for(:sign_up) << :group_key
    devise_parameter_sanitizer.for(:account_update) << :group_key
  end
end
