# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Attendee List Event Features' do
  let(:user) { create :user, :attendee }
  let!(:event) { create(:event, start_date: DateTime.now, end_date: DateTime.now + 3.hours) }

  before(:all) do
    @events = Event.all
  end

  subject do
    sign_in user, scope: :attendee
    visit attendees_events_path
  end

  it 'visits list event path' do
    subject
    expect(page).to have_content('EVENTS LIST')
  end

  it 'display all records' do
    subject
    check_list
  end

  it 'paginates to next list' do
    subject
    click_link('2')
    @events[10..19].each do |event|
      expect(page).to have_content(event.id)
    end
  end

  context 'sorts when clicked on column headers' do
    it 'sorts by ID' do
      subject
      @events = @events.order(:id)
      click_link('Id')
      check_list
    end

    it 'sorts by title' do
      subject
      @events = @events.order(:title)
      click_link('Title')
      check_list
    end

    it 'sorts by event date' do
      subject
      @events = @events.order(:start_date)
      click_link('Event Date')
      check_list
    end

    it 'sorts by location' do
      subject
      @events = @events.order(:location)
      click_link('Location')
      check_list
    end

    it 'sorts by status' do
      subject
      click_link('Status')
      @events = @events.order(:status)
      @events[0..9].each do |event|
        expect(page).to have_content(event.status)
      end
    end

    it 'sorts in descending when double click' do
      subject
      click_link('Id')
      click_link('Id')
      @events = @events.order(id: :desc)
      check_list
    end
  end

  context 'filters by status' do
    it 'filters all events' do
      subject
      select 'All Events', from: 'q[status_eq]'
      click_button 'commit'
      expect(current_path).to eql(attendees_events_path)
    end

    it 'filters upcoming events' do
      subject
      select 'Upcoming Events', from: 'q[status_eq]'
      click_button 'commit'
      @events = filter_by_status(:upcoming)
      check_list
    end

    it 'filters upcoming events' do
      subject
      select 'Past Events', from: 'q[status_eq]'
      click_button 'commit'
      @events = filter_by_status(:completed)
      check_list
    end
  end

  context 'filters by category' do
    it 'filters social events' do
      subject
      select 'Social', from: 'q[category_eq]'
      click_button 'commit'
      @events = filter_by_category('social')
      check_list
    end

    it 'filters workshop events' do
      subject
      select 'Workshop', from: 'q[category_eq]'
      click_button 'commit'
      @events = filter_by_category('workshop')
      check_list
    end

    it 'filters conference events' do
      subject
      select 'Conference', from: 'q[category_eq]'
      click_button 'commit'
      @events = filter_by_category('conference')
      check_list
    end

    it 'filters sports events' do
      subject
      select 'Sports', from: 'q[category_eq]'
      click_button 'commit'
      @events = filter_by_category('sports')
      check_list
    end
  end

  context 'filters data by search' do
    it 'title' do
      subject
      fill_in('ransack-search', with: event.title)
      click_button 'commit'
      expect(page).to have_content(event.title)
    end
    it 'description' do
      subject
      fill_in('ransack-search', with: event.description)
      click_button 'commit'
      expect(page).to have_content(event.id)
    end
    it 'location' do
      subject
      fill_in('ransack-search', with: event.location)
      click_button 'commit'
      expect(page).to have_content(event.location)
    end
  end

  it 'filters data by date' do
    subject
    fill_in('q_start_date_gteq', with: event.start_date - 1)
    fill_in('q_end_date_lteq', with: event.end_date + 1)
    click_button 'commit'
    expect(page).to have_content(event.id)
  end

  it 'show event details' do
    subject
    @events[0..9].each do |event|
      visit attendees_event_path(event.id)
      expect(page).to have_content(event.title)
    end
  end
end
