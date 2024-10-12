# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :user }

  context 'When creating a user' do
    it 'should have all attributes' do
      expect(user.valid?).to be(true)
    end

    it 'First name should not be null' do
      expect(user.first_name).to be_present
    end

    it 'Last name should not be null' do
      expect(user.last_name).to be_present
    end

    it 'Email should not be null' do
      expect(user.email).to be_present
    end

    it 'Age should not be null' do
      expect(user.age).to be_present
    end

    it 'Date of birth should not be null' do
      expect(user.date_of_birth).to be_present
    end

    it 'password should not be null' do
      expect(user.encrypted_password).to be_present
    end
  end

  context 'Model Errors' do
    it 'should have all attributes' do
      user.first_name = nil
      expect(user.valid?).to be(false)
    end
    it 'should have all attributes' do
      user.last_name = nil
      expect(user.valid?).to be(false)
    end
    it 'should have all attributes' do
      user.age = nil
      expect(user.valid?).to be(false)
    end
    it 'should have all attributes' do
      user.email = nil
      expect(user.valid?).to be(false)
    end
    it 'should have all attributes' do
      user.password = nil
      expect(user.valid?).to be(false)
    end
  end
end
