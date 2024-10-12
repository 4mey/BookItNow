# frozen_string_literal: true

require 'faker'

module Build
  # Class to build database
  class DatabaseBuilder
    def reset_data
      Event.destroy_all
      User.destroy_all
    end

    def create_users
      10.times do
        FactoryBot.create(:user)
      end
    end

    def create_events
      status = %i[upcoming ongoing completed cancelled]
      status.each do |event_status|
        20.times do
          FactoryBot.create(:event, event_status, user: User.first)
        end
      end
    end

    def generate_admin
      password = '123123'
      FactoryBot.create(:user, :event_manager, email: 'admin@email.com',
                                               password:,
                                               password_confirmation: password)
    end

    def create_rsvps
      attendees = User.attendee
      events = Event.all
      rsvp_statuses = %i[confirmed unconfirmed]
      events.each do |event|
        attendees[rand(0..4)..rand(5..9)].each do |attendee|
          FactoryBot.create(:rsvp, rsvp_statuses[rand(0..1)], user: attendee, event:)
        end
        confirmed_rsvps = event.rsvps.confirmed
        event.update(attendees_count: confirmed_rsvps.count)
      end
    end

    def execute
      reset_data
      generate_admin
      create_users
      create_events
      create_rsvps
    end

    def run
      execute
    end
  end
end
