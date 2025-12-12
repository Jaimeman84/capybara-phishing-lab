# frozen_string_literal: true

class PhishingDetectionService
  def initialize(email)
    @email = email
  end

  def analyze
    indicators = collect_indicators
    save_indicators(indicators)
    score = calculate_threat_score(indicators)
    save_threat_score(score)

    { indicators: indicators, threat_score: score }
  end

  private

  def collect_indicators
    analyzers.flat_map do |analyzer|
      analyzer.new(@email).analyze
    end
  end

  def analyzers
    [
      PhishingDetection::UrlAnalyzer,
      PhishingDetection::SenderAnalyzer,
      PhishingDetection::ContentAnalyzer,
      PhishingDetection::AttachmentAnalyzer
    ]
  end

  def save_indicators(indicators)
    indicators.each do |indicator_data|
      @email.phishing_indicators.create!(indicator_data)
    end
  end

  def calculate_threat_score(indicators)
    ThreatScoringEngine.new(@email, indicators).calculate
  end

  def save_threat_score(score)
    @email.create_threat_score!(
      score: score,
      calculated_at: Time.current
    )
  end
end
