# frozen_string_literal: true

class Email < ApplicationRecord
  # Associations
  has_one :report, dependent: :destroy
  has_many :phishing_indicators, dependent: :destroy
  has_one :threat_score, dependent: :destroy

  # Validations
  validates :sender_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :sender_name, presence: true
  validates :recipient_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true, length: { maximum: 200 }
  validates :body_plain, presence: true
  validates :received_at, presence: true

  # Enum for phishing types
  PHISHING_TYPES = %w[credential_harvest malware social_engineering bec].freeze
  validates :phishing_type, inclusion: { in: PHISHING_TYPES }, allow_nil: true

  # Scopes
  scope :recent, -> { order(received_at: :desc) }
  scope :phishing, -> { where(is_phishing: true) }
  scope :legitimate, -> { where(is_phishing: false) }
  scope :reported, -> { joins(:report) }
  scope :with_associations, -> { includes(:report, :phishing_indicators, :threat_score) }

  # Instance methods
  def reported?
    report.present?
  end

  def analyzed?
    threat_score.present?
  end

  def risk_level
    threat_score&.risk_level || 'unknown'
  end
end
