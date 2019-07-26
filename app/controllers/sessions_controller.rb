class SessionsController < DeviseTokenAuth::SessionsController
    def render_create_success
        render json: resource_data(resource_json: @resource.token_validation_response)
    end

    private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :registration, :password, :password_confirmation, :avatar])
    end
end