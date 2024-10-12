# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'When creating an event' do
    let(:event) { create :event }

    it 'should have all attributes' do
      expect(event.valid?).to be(true)
    end

    it 'title should not be null' do
      expect(event.title).to be_present
    end

    it 'description should not be null' do
      expect(event.description).to be_present
    end

    it 'used id should not be null' do
      expect(event.user_id).to be_present
    end

    it 'start date should not be null' do
      expect(event.start_date).to be_present
    end

    it 'end date should not be null' do
      expect(event.end_date).to be_present
    end

    it 'location should not be null' do
      expect(event.location).to be_present
    end

    it 'should have all attributes' do
      event.title = nil
      expect(event.valid?).to be(false)
    end

    it 'should have all attributes' do
      event.description = nil
      expect(event.valid?).to be(false)
    end

    it 'should have all attributes' do
      event.start_date = nil
      expect(event.valid?).to be(false)
    end

    it 'should have all attributes' do
      event.end_date = nil
      expect(event.valid?).to be(false)
    end

    it 'should have all attributes' do
      event.location = nil
      expect(event.valid?).to be(false)
    end

    it 'should fail if title length is less than 2 or more than 30' do
      event.title = 'a'
      expect(event.valid?).to be(false)
    end

    it 'should fail if end date is less than start date' do
      event.start_date = Date.today
      event.end_date = Date.today - 1
      expect(event.valid?).to be(false)
    end
  end
end
