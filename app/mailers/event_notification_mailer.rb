# frozen_string_literal: true

# Mailer class for Event Notifications
class EventNotificationMailer < ApplicationMailer
  def send_reminder_organiser(object)
    @event = object
    mail to: @event.user.email, subject: "Event Reminder For #{@event.title}"
  end

  def send_reminder_attendee(object)
    @rsvp = object
    mail to: @rsvp.user.email, subject: "Event Reminder For #{@rsvp.event.title}"
  end
end
