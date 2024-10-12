# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign Up features' do
  let(:user) { build :user, :attendee }

  subject do
    visit('/attendee/sign_up')
    fill_in('First name', with: user.first_name)
    fill_in('Last name', with: user.last_name)
    fill_in('Email', with: user.email)
    fill_in('Age', with: user.age)
    fill_in('Date of birth', with: user.date_of_birth)
    fill_in('user_password', with: user.password)
    fill_in('Password confirmation', with: user.password_confirmation)
  end

  context 'With valid fields' do
    it 'testing all fields' do
      subject
      click_button('Sign up')
      expect(page).to have_content('Welcome! You have signed up successfully.')
      expect(current_path).to eql('/homepage')
    end
  end

  context 'With invalid fields' do
    it 'testing fields should not be null' do
      user.first_name = nil
      user.last_name = nil
      user.email = nil
      user.age = nil
      user.date_of_birth = nil
      user.password = nil
      user.password_confirmation = nil
      subject
      click_button('Sign up')

      expect(page).to have_content("can't be blank")
    end

    it 'testing length of first and last name fields' do
      user.first_name = 'a'
      user.last_name = 'b'
      subject
      click_button('Sign up')
      expect(page).to have_content('First name is too short (minimum is 2 characters) Last name is too short (minimum is 2 characters)')
    end

    it 'first name and last name should not accept numbers' do
      user.first_name = 'a123'
      user.last_name = 'b123'
      subject
      click_button('Sign up')
      expect(page).to have_content('First name must have only alphabets Last name must have only alphabets')
    end

    it 'testing age should be in range' do
      user.age = 222
      subject
      click_button('Sign up')
      expect(page).to have_content('is invalid')
    end

    it 'testing date should be less than today' do
      user.date_of_birth = Date.today + 1
      subject
      click_button('Sign up')
      expect(page).to have_content('Date of birth must be less than today')
    end
  end
end
