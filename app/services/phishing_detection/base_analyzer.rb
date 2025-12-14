# frozen_string_literal: true

module PhishingDetection
  class BaseAnalyzer
    def initialize(email)
      @email = email
      @indicators = []
    end

    def analyze
      raise NotImplementedError, "#{self.class} must implement #analyze"
    end

    attr_reader :indicators

    private

    def add_indicator(severity, description, details = nil)
      @indicators << {
        indicator_type: indicator_type,
        severity: severity,
        description: description,
        details: details
      }
    end

    def indicator_type
      raise NotImplementedError, "#{self.class} must implement #indicator_type"
    end
  end
end
