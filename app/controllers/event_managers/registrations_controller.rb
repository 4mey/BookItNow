# frozen_string_literal: true

module EventManagers
  # Controller Class for devise registratons
  class RegistrationsController < Devise::RegistrationsController
    protected

    def update_resource(resource, params)
      if params[:password].blank?
        resource.update_without_password(params.except(:current_password))
      else
        resource.update_with_password(params)
      end
    end

    def after_update_path_for(_resource)
      edit_event_manager_registration_path
    end
  end
end
