# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API GET Request', type: :request do
  let(:token) { create :token }
  let!(:user1) { create(:user, first_name: @first_name, last_name: @last_name) }
  let!(:user2) { create(:user, first_name: @first_name, last_name: @last_name) }
  let!(:user3) { create(:user, first_name: @first_name, email: @email) }
  let(:params) { {} }
  let(:header) { { Authorization: "Bearer #{token.value}" } }

  before(:all) do
    @first_name = Faker::Name.unique.first_name
    @last_name = Faker::Name.unique.last_name
    @email = Faker::Internet.unique.email
  end

  subject do
    get '/api/v1/users', params:, headers: header
  end

  context 'without params filter' do
    it 'returns all the parameters' do
      subject
      expect(response).to have_http_status(:success)
    end
    it 'returns 13 parameters' do
      subject
      expect(json_parse.size).to eql(14)
    end
    it 'response should include only mentioned attributes' do
      subject
      first_response = json_parse.first.keys
      params = %w[id first_name last_name email date_of_birth age created_at]
      expect(first_response).to eql(params)
    end
  end
  context 'with params filter' do
    context 'returns records with single parameters' do
      it 'return records with first name filter' do
        params[:first_name] = @first_name
        subject
        expect(json_parse.size).to eql(3)
      end
      it 'return records with last name filter' do
        params[:last_name] = @last_name
        subject
        expect(json_parse.size).to eql(2)
      end
      it 'return records with email filter' do
        params[:email] = @email
        subject
        expect(json_parse.size).to eql(1)
      end
    end

    it 'returns records with multiple parameters' do
      params.merge!({ first_name: @first_name, last_name: @last_name })
      subject
      expect(response).to have_http_status(:success)
      expect(json_parse.size).to eql(2)
    end
    it 'returns no records if params dont match' do
      params[:email] = @email
      user3.destroy
      subject
      expect(json_parse.size).to eql(0)
    end

    context 'without valid token' do
      it 'fail if header does not present' do
        get('/api/v1/users')
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
end
