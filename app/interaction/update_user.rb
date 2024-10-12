# frozen_string_literal: true

# Interaction Class to update user
class UpdateUser < ActiveInteraction::Base
  object :user

  string :first_name, :last_name, :email, :password,
         default: nil

  date :date_of_birth, default: nil

  integer :age, default: nil

  validates :date_of_birth, presence: true, unless: -> { date_of_birth.nil? }

  def execute
    attributes = inputs.except(:user).compact
    errors.merge!(user.errors) unless user.update(attributes)
    user
  end
end
