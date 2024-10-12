# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event Managers Dashboard features' do
  let(:user) { create :user, :event_manager }

  subject do
    sign_in user, scope: :event_manager
    visit dashboard_path
  end

  it 'redirects to correct page' do
    subject
    expect(page).to have_content('DASHBOARD')
  end

  context 'has all the charts' do
    it 'contains user/day line chart' do
      subject
      expect(page).to have_content('Users Created per Day')
    end
    it 'contains rsvps/event category line chart' do
      subject
      expect(page).to have_content("RSVP's per Category")
    end
    it 'contains confirmed and uncomfirmed bar chart for rsvp statuses' do
      subject
      expect(page).to have_content('Rsvp Statuses')
    end
    it 'contains events/category category line chart' do
      subject
      expect(page).to have_content('Events per Category')
    end
  end

  context 'Downloads Event data through buttons' do
    it 'Downloads event data in pdf' do
      subject
      click_button 'Events Data(CSV)'
      expect(response_headers['Content-Disposition']).to match('.csv')
    end
    it 'Downloads event data in csv' do
      subject
      click_button 'Events Data(PDF)'
      expect(response_headers['Content-Disposition']).to match('.pdf')
    end
  end
end
