# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Add Events features' do
  let(:user) { create :user, :event_manager }
  let(:event) { build :event }

  subject do
    sign_in user, scope: :event_manager
    visit new_event_managers_event_path
    fill_in('Title', with: event.title)
    fill_in('Description', with: event.description)
    fill_in('Start date', with: event.start_date)
    fill_in('End date', with: event.end_date)
    fill_in('Location', with: event.location)
    select event.category, from: 'Category'
    click_button('Add Event')
  end

  it 'testing all fields' do
    subject
    expect(page).to have_content('Your Event was created and is upcoming.')
    expect(current_path).to eql(homepage_path)
  end

  it 'record has user id' do
    subject
    expect(Event.last.user_id).to eql(user.id)
  end

  it 'status is set to upcoming' do
    subject
    expect(Event.last.status).to eql('upcoming')
  end

  context 'fails if any null values' do
    it 'fails if null title' do
      event[:title] = nil
      subject
      expect(page).to have_content('Title is too short')
    end

    it 'fails if null description' do
      event[:description] = nil
      subject
      expect(page).to have_content("Description can't be blank")
    end

    it 'fails if null start date' do
      event[:start_date] = nil
      subject
      expect(page).to have_content("Start date can't be blank")
    end

    it 'fails if null end date' do
      event[:end_date] = nil
      subject
      expect(page).to have_content("End date can't be blank")
    end

    it 'fails if null location' do
      event[:location] = nil
      subject
      expect(page).to have_content("Location can't be blank")
    end
  end

  it 'fails if invalid dates' do
    event[:start_date] = Date.today
    event[:end_date] = Date.today - 1
    subject
    expect(page).to have_content('Start date must be less than end date')
    expect(current_path).to eql(event_managers_events_path)
  end

  it 'fails if invalid title' do
    event[:title] = 'a'
    subject
    expect(page).to have_content('Title is too short (minimum is 2 characters)')
    expect(current_path).to eql(event_managers_events_path)
  end

  it 'fails if start date is in past' do
    event[:start_date] = Date.today - 10
    subject
    expect(page).to have_content('Start date cannot be in past')
    expect(current_path).to eql(event_managers_events_path)
  end
end
