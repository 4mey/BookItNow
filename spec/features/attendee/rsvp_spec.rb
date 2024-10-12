# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Attendee RSVP Features' do
  let(:user) { create :user, :attendee }
  let(:event) { create :event }

  subject do
    sign_in user, scope: :attendee
    visit(attendees_event_path(event.id))
    click_button('Rsvp')
  end

  it 'create rsvp record' do
    subject
    expect(page).to have_content('Successfull RSVP')
    expect(current_path).to eql(attendees_event_path(event.id))
  end

  it 'created rsvp record has User Id' do
    subject
    expect(Rsvp.last.user_id).to eql(user.id)
  end

  it 'created rsvp record has Event Id' do
    subject
    expect(Rsvp.last.event_id).to eql(event.id)
  end

  it 'user cannot rsvp to same event more than once' do
    subject
    click_button('Rsvp')
    expect(page).to have_content("User has already rsvp'd to this event")
  end
end
