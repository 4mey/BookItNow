# frozen_string_literal: true

FactoryBot.define do
  factory :token do
    value { Digest::MD5.hexdigest(SecureRandom.hex) }
    expired_at { DateTime.now + 1 }
  end
end
