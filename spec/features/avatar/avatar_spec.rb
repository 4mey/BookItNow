# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event Manager Avatar Features' do
  describe 'Attendee Avatar Features' do
    let(:user) { create :user, :attendee }

    subject do
      visit attendee_session_path
      fill_in('Email', with: user.email)
      fill_in('Password', with: user.password)
      click_button('Log in')
      visit new_attendees_avatar_path
      expect(page).to have_content('Attach Files to Update your Avatar')
    end

    context 'Avatar is' do
      before do
        subject
        attach_file('./spec/features/avatar/user.jpg')
        click_button('Upload Avatar')
      end

      it 'updated when uploaded' do
        expect(page).to have_content('Update Successful')
      end

      it 'removed when deleted' do
        click_button('Remove Avatar')
        expect(page).to have_content('Avatar Deleted')
      end
    end

    it 'does not update when invalid' do
      subject
      attach_file('./spec/features/avatar/invalid_content_type.txt')
      click_button('Upload Avatar')
      expect(page).to have_content('Avatar has an invalid content type')
    end

    it 'throws error when file not attached' do
      subject
      click_button('Upload Avatar')
      expect(page).to have_content('Please Attach a file')
    end
  end

  describe 'Event Manager Avatar Features' do
    let(:user) { create :user, :event_manager }

    subject do
      visit event_manager_session_path
      fill_in('Email', with: user.email)
      fill_in('Password', with: user.password)
      click_button('Log in')
      visit new_event_managers_avatar_path
      expect(page).to have_content('Attach Files to Update your Avatar')
    end

    context 'Avatar is' do
      before do
        subject
        attach_file('./spec/features/avatar/user.jpg')
        click_button('Upload Avatar')
      end

      it 'updated when uploaded' do
        expect(page).to have_content('Update Successful')
      end

      it 'removed when deleted' do
        click_button('Remove Avatar')
        expect(page).to have_content('Avatar Deleted')
      end
    end

    it 'does not update when invalid' do
      subject
      attach_file('./spec/features/avatar/invalid_content_type.txt')
      click_button('Upload Avatar')
      expect(page).to have_content('Avatar has an invalid content type')
    end

    it 'throws error when file not attached' do
      subject
      click_button('Upload Avatar')
      expect(page).to have_content('Please Attach a file')
    end
  end
end
