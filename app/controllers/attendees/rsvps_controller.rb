# frozen_string_literal: true

module Attendees
  # Controller Class for Rsvp
  class RsvpsController < Attendees::ApplicationController
    def create
      @rsvp = current_attendee.rsvps.new(event_id: params[:event_id])
      if @rsvp.save
        flash[:notice] = 'Successfull RSVP'
      else
        flash[:alert] = @rsvp.errors.full_messages.join(', ')
      end
      redirect_back(fallback_location: root_path)
    end
  end
end
