# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Edit features' do
  let(:user) { create :user, :event_manager }
  let(:user1) { build :user }
  let(:inputs) do
    { first_name: user1.first_name,
      last_name: user1.last_name,
      password: user1.password,
      password_confirmation: user1.password,
      previous_password: user.password }
  end

  subject do
    sign_in user, scope: :event_manager
    visit edit_event_manager_registration_path
    fill_in('First name', with: inputs[:first_name])
    fill_in('Last name', with:  inputs[:last_name])
    fill_in('user_password', with: inputs[:password])
    fill_in('Password confirmation', with: inputs[:password_confirmation])
    fill_in('Current password', with: inputs[:previous_password])
    click_button('Update')
  end

  context 'testing fields to update' do
    it 'updates successfully' do
      subject
      expect(current_path).to eql(edit_event_manager_registration_path)
      expect(page).to have_content('Your account has been updated successfully.')
    end

    it 'updates first name' do
      subject
      user.reload
      expect(user.first_name).to eql(user1.first_name)
    end

    it 'updates last name' do
      subject
      user.reload
      expect(user.last_name).to eql(user1.last_name)
    end
  end

  it 'testing detail fields to update without password' do
    %i[password password_confirmation previous_password].each do |key|
      inputs[key] = nil
    end
    subject
    user.reload
    expect(current_path).to eql(edit_event_manager_registration_path)
    expect(user.first_name).to eql(user1.first_name)
  end

  it 'testing password to not update without current password' do
    inputs[:previous_password] = nil
    subject
    expect(page).to have_content("Current password can't be blank")
  end

  it 'testing password to not update without correct current password' do
    inputs[:previous_password] = 'abcxyz'
    subject
    expect(page).to have_content('Current password is invalid')
  end

  it 'fails if details are invalid' do
    inputs[:first_name] = Faker::Lorem.characters(number: 1)
    inputs[:last_name] = Faker::Lorem.characters(number: 1)
    subject
    expect(page).to have_content('errors prohibited this event manager from being saved')
  end
end
