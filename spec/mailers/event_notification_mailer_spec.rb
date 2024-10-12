# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventNotificationMailer, type: :mailer do
  describe 'send_reminder_organiser' do
    let(:event) { create :event }
    let(:mail) { EventNotificationMailer.send_reminder_organiser(event) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Event Reminder For #{event.title}")
      expect(mail.to).to eq([event.user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('All the best! All the attendess have been informed')
    end
  end

  describe 'send_reminder_attendee' do
    let(:event) { create :event }
    let(:user) { create :user, :attendee }
    let(:rsvp) { create(:rsvp, user:, event:) }
    let(:mail) { EventNotificationMailer.send_reminder_attendee(rsvp) }

    it 'renders the headers' do
      expect(mail.subject).to eq("Event Reminder For #{event.title}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Get ready with your stuff. Hope you have fun')
    end
  end
end
