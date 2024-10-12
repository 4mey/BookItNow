# frozen_string_literal: true

# Model Class to handle users
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :created_events, class_name: 'Event', dependent: :destroy

  has_many :events, through: :rsvps
  has_many :rsvps, dependent: :destroy

  enum :role_type, %i[event_manager attendee], default: 1
  enum :status, %i[active suspended], default: 0

  validates :first_name,
            :last_name,
            length: { minimum: 2, maximum: 30 },
            format: { with: /\A[A-Za-z ,.'-]+\z/,
                      message: 'must have only alphabets' }

  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 1,
                                  less_than_or_equal_to: 115,
                                  message: 'is invalid' }

  validates :date_of_birth, presence: true

  # validates :avatar, content_type: %w[image/png image/jpeg],
  #                    dimension: { width: { max: 1600 },
  #                                 height: { max: 1200 }, message: 'dimensions are too high. Maximum dimensions can be 1600x1200' },
  #                    size: { less_than: 10.megabytes, message: 'size is too high. Maximum size can be 10 MB' }

  validate :date_is_less_than_today

  scope :filtered_by_first_name, ->(first_name) { where(first_name:) if first_name.present? }
  scope :filtered_by_last_name, ->(last_name) { where(last_name:) if last_name.present? }
  scope :filtered_by_email, ->(email) { where(email:) if email.present? }

  def self.ransackable_attributes(_auth_object = nil)
    column_names + _ransackers.keys
  end

  def self.ransackable_associations(_auth_object = nil)
    reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
  end

  private

  def date_is_less_than_today
    return unless date_of_birth.present?

    errors.add(:date_of_birth, 'must be less than today') unless date_of_birth < Date.today
  end
end
