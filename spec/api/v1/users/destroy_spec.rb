# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API DELETE Request', type: :request do
  let(:header) { { Authorization: "Bearer #{token.value}" } }
  let(:token) { create :token }

  before do
    @user_id = User.last[:id]
  end

  subject do
    delete("/api/v1/users/#{@user_id}", headers: header)
  end

  it 'Delete with ID' do
    subject
    expect(response).to have_http_status(200)
  end
  it 'Record is deleted' do
    expect { subject }.to change { User.count }.by(-1)
  end
  it 'fail when ID does not exist' do
    User.last.destroy
    subject
    expect(response).to have_http_status(404)
  end

  context 'without valid token' do
    it 'fail if header does not present' do
      delete("/api/v1/users/#{@user_id}")
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
