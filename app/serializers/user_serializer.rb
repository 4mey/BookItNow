# frozen_string_literal: true

# Serializer used for API response
class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :date_of_birth, :age, :created_at
end
