# frozen_string_literal: true

# Model Class for Token Records
class Token < ApplicationRecord
  before_validation :generate_token, on: :create

  private

  def generate_token
    self.value = Digest::MD5.hexdigest(SecureRandom.hex)
    self.expired_at = DateTime.now + 1
  end
end
