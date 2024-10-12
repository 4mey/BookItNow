# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Delete Events features' do
  let(:user) { create :user, :event_manager }
  let!(:event) { create :event, user_id: user.id }

  subject do
    sign_in user, scope: :event_manager
    visit event_managers_event_path(event.id)
    click_link('Delete')
  end

  it 'deletes successfully' do
    subject
    expect(page).to have_content('Event Deleted')
    expect(current_path).to eql(event_managers_events_path)
  end

  it 'record is deleted' do
    expect { subject }.to change { Event.count }.by(-1)
  end
end
