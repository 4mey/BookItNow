# frozen_string_literal: true

require 'rails_helper'

# Advised to seed the test database before running rpsec tests

RSpec.describe 'API PUT Request', type: :request do
  let(:token) { create :token }
  let(:header) { { Authorization: "Bearer #{token.value}" } }
  let(:user_params) do
    { user: { first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              age: Faker::Number.between(from: 18, to: 115),
              date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 95),
              password: Faker::Internet.password } }
  end

  before do
    @user_id = User.last[:id]
  end

  def update_user(user_params)
    put("/api/v1/users/#{@user_id}", params: user_params, headers: header)
  end

  it 'Update with ID' do
    update_user(user_params)
    expect(response).to have_http_status(200)
  end
  context 'should update single entities' do
    it 'update only first name' do
      first_name =  Faker::Name.first_name
      user_params = { user: { first_name: } }
      update_user(user_params)
      expect(User.last.first_name).to eql(first_name)
    end
    it 'update only last name' do
      last_name = Faker::Name.last_name
      user_params = { user: { last_name: } }
      update_user(user_params)
      expect(User.last.last_name).to eql(last_name)
    end
    it 'update only email' do
      email = Faker::Internet.email
      user_params = { user: { email: } }
      update_user(user_params)
      expect(User.last.email).to eql(email)
    end
    it 'update only age' do
      age = Faker::Number.between(from: 18, to: 115)
      user_params = { user: { age: } }
      update_user(user_params)
      expect(User.last.age).to eql(age)
    end
    it 'update only date of birth' do
      date_of_birth = Faker::Date.birthday(min_age: 18, max_age: 95)
      user_params = { user: { date_of_birth: } }
      update_user(user_params)
      expect(User.last.date_of_birth).to eql(date_of_birth)
    end
    it 'update only password' do
      user_password = User.last.encrypted_password
      password = Faker::Internet.password
      user_params = { user: { password: } }
      update_user(user_params)
      expect(User.last.encrypted_password).not_to eql(user_password)
    end
  end
  it 'fail when ID does not exist' do
    User.last.destroy
    update_user(user_params)
    expect(response).to have_http_status(404)
  end
  context 'fail when request is not validated' do
    it 'first name and last name validations' do
      user_params = { user: { first_name: 'John123',
                              last_name: 'Kates123' } }
      update_user(user_params)
      errors = '"first_name":["must have only alphabets"],"last_name":["must have only alphabets"]}'
      expect(response.body).to include(errors)
    end
    it 'age validations' do
      user_params = { user: { age: 'abc' } }
      update_user(user_params)
      error = '{"age":["is not a valid integer"]}'
      expect(response.body).to include(error)
    end
    it 'password validations' do
      user_params = { user: { password: '123' } }
      update_user(user_params)
      error = '"password":["is too short (minimum is 6 characters)"]'
      expect(response.body).to include(error)
    end
    it 'date format validations' do
      user_params = { user: {  date_of_birth: '1234abc' } }
      update_user(user_params)
      error = '{"date_of_birth":["is not a valid date"]}'
      expect(response.body).to include(error)
    end
    it 'date validations' do
      user_params = { user: {  date_of_birth: Date.today + 1 } }
      update_user(user_params)
      error = '{"date_of_birth":["must be less than today"]}'
      expect(response.body).to include(error)
    end
  end
  context 'without valid token' do
    it 'fail if header does not present' do
      put("/api/v1/users/#{@user_id}", params: user_params)
      expect(response).to have_http_status(:unauthorized)
    end
    it 'fail if token value not found' do
      header[:Authorization] = 'Bearer abcabc'
      update_user(user_params)
      expect(response).to have_http_status(:unauthorized)
    end
    it 'fail if token has expired' do
      token.update_attribute(:expired_at, DateTime.now - 1)
      update_user(user_params)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
