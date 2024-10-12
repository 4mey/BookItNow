# frozen_string_literal: true

# Base class for the Application
class ApplicationController < ActionController::Base
  before_action :configure_params, if: :devise_controller?
  add_flash_types :warnings

  def configure_params
    params = %i[first_name last_name email age date_of_birth password
                password_confirmation avatar role_type status]
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: params)
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: params)
  end

  private

  def check_signed_in
    return unless signed_in?

    redirect_to homepage_path
    flash[:alert] = 'Unauthorized Access'
  end

  def authenticate_admin!
    token = request.headers['Authorization'].split.last if request.headers['Authorization']
    current_token = Token.find_by_value(token)
    render json: { error: 'authorization failed' }, status: :unauthorized if current_token.nil? || current_token.expired_at < DateTime.now
  end
end
