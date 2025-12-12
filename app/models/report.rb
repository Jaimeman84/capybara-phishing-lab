# frozen_string_literal: true

class Report < ApplicationRecord
  # Associations
  belongs_to :email

  # Validations
  validates :email_id, uniqueness: true
  validates :reported_at, presence: true

  # Callbacks
  before_validation :set_reported_at, on: :create

  private

  def set_reported_at
    self.reported_at ||= Time.current
  end
end
