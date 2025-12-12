# frozen_string_literal: true

class PhishingIndicator < ApplicationRecord
  # Associations
  belongs_to :email

  # Constants
  INDICATOR_TYPES = %w[url sender content attachment].freeze
  SEVERITIES = %w[low medium high critical].freeze

  # Validations
  validates :indicator_type, presence: true, inclusion: { in: INDICATOR_TYPES }
  validates :severity, presence: true, inclusion: { in: SEVERITIES }
  validates :description, presence: true, length: { maximum: 500 }

  # Scopes
  scope :by_type, ->(type) { where(indicator_type: type) }
  scope :by_severity, ->(severity) { where(severity: severity) }
  scope :high_severity, -> { where(severity: %w[high critical]) }
end
