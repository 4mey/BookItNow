# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Attendee access features' do
  let(:user) { create :user, :attendee }

  subject do
    sign_in user, scope: :attendee
  end

  context 'Checking Attendee' do
    it 'Can access attendee routes' do
      subject
      visit(new_attendees_avatar_path)
      expect(page).to have_content('Attach Files to Update your Avatar')
      expect(current_path).to eql(new_attendees_avatar_path)
    end

    it 'Cannot login as incorrect role type' do
      visit(event_manager_session_path)
      fill_in('Email', with: user.email)
      fill_in('Password', with: user.password)
      click_button('Log in')
      expect(page).to have_content('Unauthorized Access')
    end

    it 'cannot access paths of different role type' do
      subject
      visit(new_event_managers_avatar_path)
      expect(page).to have_content('Unauthorized Access')
      expect(current_path).to eql(homepage_path)
    end
  end
end

RSpec.describe 'Event Manager access features' do
  let(:user) { create :user, :event_manager }

  subject do
    sign_in user, scope: :event_manager
  end

  context 'Checking Event Manager' do
    it 'Can access manager routes' do
      subject
      visit(new_event_managers_avatar_path)
      expect(page).to have_content('Attach Files to Update your Avatar')
      expect(current_path).to eql(new_event_managers_avatar_path)
    end

    it 'Cannot login as incorrect role type' do
      visit(attendee_session_path)
      fill_in('Email', with: user.email)
      fill_in('Password', with: user.password)
      click_button('Log in')
      expect(page).to have_content('Unauthorized Access')
    end

    it 'cannot access paths of different role type' do
      subject
      visit(new_attendees_avatar_path)
      expect(page).to have_content('Unauthorized Access')
      expect(current_path).to eql(homepage_path)
    end
  end
end
