# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Attendee Sign In features' do
  let(:user) { create :user, :attendee }

  subject do
    visit('/attendee/sign_in')
    fill_in('Email', with: user.email)
    fill_in('Password', with: user.password)
  end

  context 'Valid Fields' do
    it 'testing sign in' do
      subject
      click_button('Log in')
      expect(page).to have_content('Signed in successfully')
      expect(current_path).to eql('/homepage')
    end
  end

  context 'Invalid Fields' do
    it 'testing sign in to fail with blank email' do
      subject
      fill_in('Email', with: nil)
      click_button('Log in')
      expect(page).to have_content('Unauthorized Access')
    end

    it 'testing sign in to fail with blank password' do
      subject
      fill_in('Password', with: nil)
      click_button('Log in')
      expect(page).to have_content('Invalid Email or password')
    end

    it 'testing sign in to fail with invalid email' do
      subject
      fill_in('Email', with: 'abcgmail')
      click_button('Log in')
      expect(page).to have_content('Unauthorized Access')
    end

    it 'testing sign in to fail with non existent email' do
      subject
      fill_in('Email', with: 'abc@gmail')
      click_button('Log in')
      expect(page).to have_content('Unauthorized Access')
    end

    it 'testing sign in to fail with wrong password' do
      subject
      fill_in('Password', with: 'abcxyz')
      click_button('Log in')
      expect(page).to have_content('Invalid Email or password')
    end
  end
end
