# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update Events features' do
  let(:user) { create :user, :event_manager }
  let(:existing_event) { create :event, user: }
  let(:event) { build :event }

  subject do
    sign_in user, scope: :event_manager
    visit edit_event_managers_event_path(existing_event.id)
    fill_in('Title', with: event.title)
    fill_in('Description', with: event.description)
    fill_in('Start date', with: event.start_date)
    fill_in('End date', with: event.end_date)
    fill_in('Location', with: event.location)
    select event.category, from: 'Category'
    click_button('Save Changes')
  end

  it 'testing all fields to update' do
    subject
    expect(page).to have_content('Your Event was Updated')
    expect(current_path).to eql(edit_event_managers_event_path(existing_event.id))
  end

  it 'fails if null value' do
    event.title = nil
    event.description = nil
    event.start_date = nil
    event.end_date = nil
    subject
    expect(page).to have_content("can't be blank")
  end

  it 'fails if invalid dates' do
    event.start_date = Date.today
    event.end_date = Date.today - 1
    subject
    expect(page).to have_content('Start date must be less than end date')
  end

  it 'fails if invalid title' do
    event.title = 'a'
    subject
    expect(page).to have_content('Title is too short (minimum is 2 characters)')
  end

  context 'Update single fields' do
    before do
      sign_in user, scope: :event_manager
      visit edit_event_managers_event_path(existing_event.id)
    end

    it 'only title' do
      fill_in('Title', with: event.title)
      click_button('Save Changes')
      existing_event.reload
      expect(existing_event.title).to eql(event.title)
    end

    it 'only description' do
      fill_in('Description', with: event.description)
      click_button('Save Changes')
      existing_event.reload
      expect(existing_event.description).to eql(event.description)
    end

    it 'only start date' do
      fill_in('Start date', with: event.start_date)
      click_button('Save Changes')
      existing_event.reload
      expect(existing_event.start_date.to_date).to eql(event.start_date.to_date)
    end

    it 'only end date' do
      fill_in('End date', with: event.end_date)
      click_button('Save Changes')
      existing_event.reload
      expect(existing_event.end_date.to_date).to eql(event.end_date.to_date)
    end

    it 'only location' do
      fill_in('Location', with: event.location)
      click_button('Save Changes')
      existing_event.reload
      expect(existing_event.location).to eql(event.location)
    end

    it 'only category' do
      select event.category, from: 'Category'
      click_button('Save Changes')
      existing_event.reload
      expect(existing_event.category).to eql(event.category)
    end
  end
end
