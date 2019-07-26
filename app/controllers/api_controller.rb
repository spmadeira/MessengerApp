class ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :registration, :password, :password_confirmation, :avatar])
  end
end
