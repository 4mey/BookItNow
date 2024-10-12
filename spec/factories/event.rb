# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.paragraphs(number: rand(2..8)).join }
    start_date { Faker::Time.between(from: DateTime.now, to: DateTime.now + 10) }
    end_date { Faker::Time.between(from: DateTime.now + 11, to: DateTime.now + 20) }
    category { rand(0..3) }
    location { Faker::Address.city }
    user

    trait :upcoming do
      status { :upcoming }
      start_date { Faker::Time.between(from: DateTime.now, to: DateTime.now + 10) }
      end_date { Faker::Time.between(from: DateTime.now + 11, to: DateTime.now + 20) }
    end

    trait :completed do
      status { :completed }
      start_date { Faker::Time.between(from: DateTime.now - 20, to: DateTime.now - 10) }
      end_date { Faker::Time.between(from: DateTime.now - 9, to: DateTime.now) }
    end

    trait :ongoing do
      status { :ongoing }
      start_date { Faker::Time.between(from: DateTime.now - 10, to: DateTime.now - 1) }
      end_date { Faker::Time.between(from: DateTime.now, to: DateTime.now + 10) }
    end

    trait :cancelled do
      status { :cancelled }
      start_date { Faker::Time.between(from: DateTime.now - 30, to: DateTime.now - 1) }
      end_date { Faker::Time.between(from: DateTime.now, to: DateTime.now + 10) }
    end
  end
end
