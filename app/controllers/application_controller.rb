class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    '/main'
  end

  def after_sign_up_path_for(resource)
    '/main'
  end
end
