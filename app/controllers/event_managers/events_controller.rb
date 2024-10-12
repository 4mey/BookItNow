# frozen_string_literal: true

# Class for home controller
module EventManagers
  # Event Controller for Event Managers
  class EventsController < EventManagers::ApplicationController
    before_action :find_event, only: %i[show update destroy edit]
    before_action :check_creator, only: %i[edit update destroy]

    def new
      @event = Event.new
    end

    def index
      @q = Event.ransack(params[:q])
      @events = @q.result.paginate(page: params[:page], per_page: 10)
    end

    def create
      @event = current_event_manager.created_events.new(event_params)
      if @event.save
        send_reminder
        flash[:notice] = 'Your Event was created and is upcoming.'
        redirect_to homepage_path
      else
        flash[:warnings] = @event.errors.full_messages
        render :new, status: :unprocessable_entity
      end
    end

    def show; end

    def edit; end

    def destroy
      @event.destroy
      flash[:notice] = 'Event Deleted'
      redirect_to event_managers_events_path
    end

    def update
      start_date = @event.start_date
      if @event.update(event_params)
        send_reminder if start_date != @event.start_date
        flash[:notice] = 'Your Event was Updated'
        redirect_to edit_event_managers_event_path
      else
        flash[:erorrs] = @event.errors.full_messages
        render :edit, status: :unprocessable_entity
      end
    end

    def send_reminder
      notification_time = 1.day.ago(@event.start_date)
      event_date = @event.start_date.to_json
      ReminderMailerJob.perform_at(notification_time, @event.id, event_date)
    end

    def download
      respond_to do |format|
        format.csv { send_data Event.to_csv, filename: "events-#{Date.today}.csv" }
        format.pdf { send_data Event.to_pdf, filename: "events-#{Date.today}.pdf" }
      end
    end

    private

    def find_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title,
                                    :description,
                                    :start_date,
                                    :end_date,
                                    :location,
                                    :category)
    end
  end
end
