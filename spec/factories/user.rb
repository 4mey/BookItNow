# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    age { Faker::Number.between(from: 18, to: 115) }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 95) }
    password { '123456' }
    password_confirmation { '123456' }
    status { 0 }
    created_at { Faker::Time.between(from: DateTime.now - 20, to: DateTime.now) }
  end

  trait :event_manager do
    role_type { 0 }
  end

  trait :attendee do
    role_type { 1 }
  end
end
