# frozen_string_literal: true

# Interaction Class to create users
class CreateUser < ActiveInteraction::Base
  string :first_name, :last_name, :email, :password
  date :date_of_birth
  integer :age

  validates :date_of_birth, presence: true

  def execute
    user = User.new(inputs)
    errors.merge!(user.errors) unless user.save
    user
  end
end
