# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API GET Request', type: :request do
  let(:token) { create :token }
  let(:header) { { Authorization: "Bearer #{token.value}" } }
  let(:user) { User.last }

  subject do
    get("/api/v1/users/#{user.id}", headers: header)
  end

  it 'Show with ID' do
    subject
    expect(response).to have_http_status(200)
  end
  it 'Displays all required attributes ' do
    subject
    expect(response.body).to include(user.id.to_s, user.first_name, user.last_name, user.email, user.created_at.to_json)
  end
  it 'fail when ID does not exist' do
    subject
    get "/api/v1/users/#{user.id + 1}"
    expect(response).to have_http_status(404)
  end

  context 'without valid token' do
    it 'fail if header does not present' do
      get "/api/v1/users/#{user.id}"
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
