# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API POST Request', type: :request do
  let(:token) { create :token }
  let(:header) { { Authorization: "Bearer #{token.value}" } }
  let(:params) do
    { user: { first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              age: Faker::Number.between(from: 18, to: 115),
              date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 95),
              password: Faker::Internet.password } }
  end

  subject do
    post('/api/v1/users', params:, headers: header)
  end

  it 'create a new book' do
    expect { subject }.to(change { User.count })

    expect(response).to have_http_status(201)
  end
  context 'Failure' do
    it 'if first name is missing' do
      params[:user].delete(:first_name)
      subject
      expect(response.body).to eql('{"first_name":["is required"]}')
    end
    it 'if last name is missing' do
      params[:user].delete(:last_name)
      subject
      expect(response.body).to eql('{"last_name":["is required"]}')
    end
    it 'if email is missing' do
      params[:user].delete(:email)
      subject
      expect(response.body).to eql('{"email":["is required"]}')
    end
    it 'if age is missing' do
      params[:user].delete(:age)
      subject
      expect(response.body).to eql('{"age":["is required"]}')
    end
    it 'if date of birth is missing' do
      params[:user].delete(:date_of_birth)
      subject
      expect(response.body).to eql('{"date_of_birth":["is required"]}')
    end
    it 'if password is missing' do
      params[:user].delete(:password)
      subject
      expect(response.body).to eql('{"password":["is required"]}')
    end
  end
  it 'status should be unprocessable' do
    params.delete(:user)
    subject
    expect(response).to have_http_status(422)
  end
  context 'Failure on' do
    it 'age validations' do
      params[:user][:age] = 'aa'
      subject
      expect(response.body).to eql('{"age":["is not a valid integer"]}')
    end
    it 'name formats validations' do
      params[:user][:first_name] = 'aa1234'
      params[:user][:last_name] = 'bb1234'
      subject
      expect(response.body).to eql('{"first_name":["must have only alphabets"],"last_name":["must have only alphabets"]}')
    end
    it 'date validations' do
      params[:user][:date_of_birth] = Date.today + 1
      subject
      expect(response.body).to eql('{"date_of_birth":["must be less than today"]}')
    end
    it 'date format validations' do
      params[:user][:date_of_birth] = '123123'
      subject
      expect(response.body).to eql('{"date_of_birth":["is not a valid date"]}')
    end
    it 'email uniqueness' do
      create :user, email: params[:user][:email]
      subject
      expect(response.body).to eql('{"email":["has already been taken"]}')
    end
  end
  context 'without valid token' do
    it 'fail if header does not present' do
      post('/api/v1/users', params:)
      expect(response).to have_http_status(:unauthorized)
    end
    it 'fail if token value not found' do
      header[:Authorization] = 'Bearer abcabc'
      subject
      expect(response).to have_http_status(:unauthorized)
    end
    it 'fail if token has expired' do
      token.update_attribute(:expired_at, DateTime.now - 1)
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
