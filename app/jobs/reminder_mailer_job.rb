# frozen_string_literal: true

# Job class for Reminder Mailer
class ReminderMailerJob
  include Sidekiq::Job

  def perform(event_id, initial_date)
    event = Event.find(event_id)
    return unless event.start_date.to_json == initial_date

    EventNotificationMailer.send_reminder_organiser(event).deliver_now

    rsvps = event.rsvps.confirmed
    rsvps.each do |rsvp|
      EventNotificationMailer.send_reminder_attendee(rsvp).deliver_now
    end
  end
end
