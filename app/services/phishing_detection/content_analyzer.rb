# frozen_string_literal: true

module PhishingDetection
  class ContentAnalyzer < BaseAnalyzer
    URGENCY_KEYWORDS = ['urgent', 'immediate', 'act now', 'expire', 'suspended', 'verify', 'confirm', 'action required'].freeze
    CREDENTIAL_KEYWORDS = ['password', 'login', 'username', 'account', 'verify account', 'update payment', 'billing information'].freeze

    def analyze
      check_urgency_language
      check_credential_requests
      check_generic_greeting
      @indicators
    end

    private

    def indicator_type
      'content'
    end

    def content
      [@email.subject, @email.body_plain].join(' ').downcase
    end

    def check_urgency_language
      URGENCY_KEYWORDS.each do |keyword|
        next unless content.include?(keyword)

        add_indicator('medium', "Urgency language detected: '#{keyword}'", keyword)
      end
    end

    def check_credential_requests
      CREDENTIAL_KEYWORDS.each do |keyword|
        next unless content.include?(keyword)

        add_indicator('high', "Credential request detected: '#{keyword}'", keyword)
        break
      end
    end

    def check_generic_greeting
      generic_greetings = ['dear customer', 'dear user', 'dear member', 'valued customer']
      return unless generic_greetings.any? { |greeting| content.include?(greeting) }

      add_indicator('low', 'Generic greeting detected (not personalized)', 'generic_greeting')
    end
  end
end
