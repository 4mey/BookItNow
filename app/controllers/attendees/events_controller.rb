# frozen_string_literal: true

# Class for home controller
module Attendees
  # Event Controller for Event Managers
  class EventsController < Attendees::ApplicationController
    def index
      @q = Event.ransack(params[:q])
      @events = @q.result
      @events = @events.paginate(page: params[:page], per_page: 10)
    end

    def upcoming_events
      @q = Event.completed.ransack(params[:q])
      @events = @q.result
      @events = @events.paginate(page: params[:page], per_page: 10)
    end

    def past_events
      @q = Event.upcoming.ransack(params[:q])
      @events = @q.result
      @events = @events.paginate(page: params[:page], per_page: 10)
    end

    def show
      @event = Event.find(params[:id])
    end
  end
end
