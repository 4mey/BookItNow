# frozen_string_literal: true

module EventManagers
  # Controller Class for Rsvp
  class RsvpsController < EventManagers::ApplicationController
    def index
      @event = Event.find(params[:event_id])
      check_creator
      @rsvps = @event.rsvps.includes(:user)
      @q = @rsvps.ransack(params[:q])
      @rsvps = @q.result.paginate(page: params[:page], per_page: 10)
    end

    def update
      @rsvp = Rsvp.find(params[:id])
      if @rsvp.rsvp_status == 'unconfirmed'
        @rsvp.approve!
        flash[:notice] = "#{@rsvp.user.first_name}'s Rsvp Confirmed"
      else
        @rsvp.disapprove!
        flash[:notice] = "#{@rsvp.user.first_name}'s Rsvp Unconfirmed"
      end
      update_attendees_count
      redirect_back(fallback_location: root_path)
    end

    private

    def update_attendees_count
      confirmed_rsvps = @rsvp.event.rsvps.confirmed
      @rsvp.event.update(attendees_count: confirmed_rsvps.count)
    end
  end
end
