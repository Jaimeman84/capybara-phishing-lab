# frozen_string_literal: true

class ThreatScore < ApplicationRecord
  # Associations
  belongs_to :email

  # Constants
  RISK_LEVELS = %w[low medium high critical].freeze

  # Validations
  validates :email_id, uniqueness: true
  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :risk_level, presence: true, inclusion: { in: RISK_LEVELS }
  validates :calculated_at, presence: true

  # Callbacks
  before_validation :set_calculated_at, on: :create
  before_validation :set_risk_level_from_score

  # Scopes
  scope :low_risk, -> { where(risk_level: 'low') }
  scope :medium_risk, -> { where(risk_level: 'medium') }
  scope :high_risk, -> { where(risk_level: 'high') }
  scope :critical_risk, -> { where(risk_level: 'critical') }
  scope :by_risk, ->(level) { where(risk_level: level) }

  private

  def set_calculated_at
    self.calculated_at ||= Time.current
  end

  def set_risk_level_from_score
    return if score.nil?

    self.risk_level = case score
                      when 0..25 then 'low'
                      when 26..50 then 'medium'
                      when 51..75 then 'high'
                      when 76..100 then 'critical'
                      end
  end
end
