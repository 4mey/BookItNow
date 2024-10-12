# frozen_string_literal: true

module EventManagers
  # Event Controller for Event Managers
  class ApplicationController < ApplicationController
    before_action :authenticate_event_manager!

    private

    def check_creator
      return if current_event_manager.id == @event.user_id

      flash[:alert] = 'Unauthorized access'
      redirect_to event_managers_events_path
    end
  end
end
