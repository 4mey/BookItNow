# frozen_string_literal: true

# Model class for rsvp
class Rsvp < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates_uniqueness_of :user_id, scope: %i[event_id], message: "has already rsvp'd to this event"

  include AASM

  aasm column: 'rsvp_status' do
    state :unconfirmed, initial: true
    state :confirmed

    event :approve do
      transitions from: :unconfirmed, to: :confirmed
    end

    event :disapprove do
      transitions from: :confirmed, to: :unconfirmed
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    column_names + _ransackers.keys
  end

  def self.ransackable_associations(_auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end
end
