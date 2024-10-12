# frozen_string_literal: true

module Attendees
  # Devise session controller for attendees
  class SessionsController < Devise::SessionsController
    before_action :check_signed_in, only: %i[new]

    def create
      user = User.find_by_email(params[:attendee][:email])
      if user&.attendee?
        super
      else
        flash[:alert] = 'Unauthorized Access'
        redirect_back(fallback_location: root_path)
      end
    end

    private

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
    end
  end
end
