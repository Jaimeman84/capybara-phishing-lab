# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhishingDetection::UrlAnalyzer do
  describe '#analyze' do
    it 'detects suspicious TLD in URL' do
      email = create(:email, body_plain: 'Visit http://malicious-site.tk for more')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'url',
                                      severity: 'high',
                                      description: include('Suspicious top-level domain')
                                    ))
    end

    it 'detects URL shorteners' do
      email = create(:email, body_plain: 'Click here: http://bit.ly/abc123')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'url',
                                      severity: 'medium',
                                      description: include('URL shortener detected')
                                    ))
    end

    it 'detects IP-based URLs' do
      email = create(:email, body_plain: 'Visit http://192.168.1.1/phishing')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'url',
                                      severity: 'high',
                                      description: include('IP address-based URL')
                                    ))
    end

    it 'extracts multiple URLs from body' do
      email = create(:email, body_plain: 'Visit http://site1.tk and http://bit.ly/test')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators.length).to be >= 2
    end

    it 'handles emails with no URLs' do
      email = create(:email, body_plain: 'This email contains no URLs.')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to be_empty
    end

    it 'handles HTTPS URLs' do
      email = create(:email, body_plain: 'Secure site: https://malicious.tk')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'url',
                                      severity: 'high'
                                    ))
    end

    it 'deduplicates identical URLs' do
      email = create(:email, body_plain: 'Visit http://bit.ly/test twice: http://bit.ly/test')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      url_indicators = indicators.select { |i| i[:description].include?('URL shortener') }
      expect(url_indicators.length).to eq(1)
    end
  end
end
