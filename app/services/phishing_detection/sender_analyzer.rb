# frozen_string_literal: true

module PhishingDetection
  class SenderAnalyzer < BaseAnalyzer
    FREE_EMAIL_PROVIDERS = %w[gmail.com yahoo.com hotmail.com outlook.com aol.com].freeze

    def analyze
      check_free_email_provider
      check_suspicious_sender_name
      @indicators
    end

    private

    def indicator_type
      'sender'
    end

    def check_free_email_provider
      domain = @email.sender_email.split('@').last&.downcase
      return unless FREE_EMAIL_PROVIDERS.include?(domain)

      add_indicator('low', "Email from free provider: #{domain}", domain)
    end

    def check_suspicious_sender_name
      suspicious_keywords = %w[admin support noreply no-reply service helpdesk security urgent]
      name = @email.sender_name.downcase

      suspicious_keywords.each do |keyword|
        next unless name.include?(keyword)

        add_indicator('medium', "Generic sender name detected: #{@email.sender_name}", keyword)
        break
      end
    end
  end
end
