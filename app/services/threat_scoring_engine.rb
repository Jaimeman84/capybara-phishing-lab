# frozen_string_literal: true

class ThreatScoringEngine
  WEIGHTS = {
    'url' => { 'low' => 5, 'medium' => 10, 'high' => 15, 'critical' => 25 },
    'sender' => { 'low' => 5, 'medium' => 15, 'high' => 25, 'critical' => 30 },
    'content' => { 'low' => 5, 'medium' => 10, 'high' => 20, 'critical' => 25 },
    'attachment' => { 'low' => 5, 'medium' => 15, 'high' => 25, 'critical' => 30 }
  }.freeze

  def initialize(email, indicators)
    @email = email
    @indicators = indicators
  end

  def calculate
    total_score = @indicators.sum do |indicator|
      type = indicator[:indicator_type]
      severity = indicator[:severity]
      WEIGHTS.dig(type, severity) || 0
    end

    [total_score, 100].min
  end
end
