# frozen_string_literal: true

# Controller Class for Avatar
module EventManagers
  # Controller class for Event Managers Avatar
  class AvatarsController < EventManagers::ApplicationController
    before_action :check_empty_input, only: :update

    def new; end

    def update
      if current_event_manager.update(avatar: params[:event_manager][:avatar])
        flash[:notice] = 'Update Successful'
      else
        flash[:warnings] = current_event_manager.errors.full_messages
      end
      redirect_to new_event_managers_avatar_path
    end

    def destroy
      current_event_manager.avatar.purge
      flash[:notice] = 'Avatar Deleted'
      redirect_to new_event_managers_avatar_path
    end

    def check_empty_input
      return unless params[:event_manager].blank?

      redirect_to new_event_managers_avatar_path
      flash[:warnings] = 'Please Attach a file'
    end
  end
end
