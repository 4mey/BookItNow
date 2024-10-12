# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event Managers List Attendee Features' do
  let!(:user) { create :user, :attendee }
  let!(:user1) { create :user, :event_manager }
  let!(:event) { create(:event, user_id: user1.id) }
  let!(:rsvp) { create(:rsvp, user:, event:) }

  subject do
    sign_in user1, scope: :event_manager
    visit(event_managers_event_rsvps_path(event.id))
  end

  it 'visits list attendee path' do
    subject
    expect(page).to have_content("RSVP'd ATTENDEES FOR :")
  end

  it 'has attendee details' do
    subject
    expect(page).to have_content(user.email)
  end

  context 'status is changed by buttons' do
    before do
      subject
      click_button('Confirm')
    end

    it 'changes the status when confirm button is clicked' do
      expect(page).to have_content("#{user.first_name}'s Rsvp Confirmed")
    end

    it 'changes the status when unconfirm button is clicked' do
      click_button('Unconfirm')
      expect(page).to have_content("#{user.first_name}'s Rsvp Unconfirmed")
    end
  end

  it 'changes the attendees count when action is performed' do
    subject
    expect do
      click_button('Confirm')
      event.reload
    end.to change { event.attendees_count }.by(1)
  end
end
