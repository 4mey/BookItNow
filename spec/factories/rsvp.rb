# frozen_string_literal: true

FactoryBot.define do
  factory :rsvp do
    association :user
    association :event
  end

  trait :confirmed do
    rsvp_status { :confirmed }
  end

  trait :unconfirmed do
    rsvp_status { :unconfirmed }
  end
end
