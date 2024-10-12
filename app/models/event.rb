# frozen_string_literal: true

# Model class for event
class Event < ApplicationRecord
  include ExportCsv
  include ExportPdf
  include AASM

  belongs_to :user

  has_many :rsvps, dependent: :destroy
  has_many :users, through: :rsvps

  validates :description,
            :start_date,
            :end_date,
            :location,
            :category, presence: true

  validates :title, length: { minimum: 2, maximum: 30 }

  attribute :attendees_count, default: 0

  validate :dates_range

  aasm column: 'status' do
    state :upcoming, initial: true
    state :ongoing
    state :completed
    state :cancelled
  end

  enum :category, %i[conference social sports workshop]

  def self.ransackable_attributes(_auth_object = nil)
    column_names + _ransackers.keys
  end

  def self.ransackable_associations(_auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end

  private

  def dates_range
    return if start_date.nil? || end_date.nil? || status != 'upcoming'

    errors.add(:start_date, 'must be less than end date') unless start_date <= end_date
    errors.add(:start_date, 'cannot be in past') unless start_date > Date.yesterday
  end
end
