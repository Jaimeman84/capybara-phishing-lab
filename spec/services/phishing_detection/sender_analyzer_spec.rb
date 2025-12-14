# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhishingDetection::SenderAnalyzer do
  describe '#analyze' do
    it 'detects free email provider' do
      email = create(:email, sender_email: 'test@gmail.com')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'sender',
                                      severity: 'low',
                                      description: include('free provider')
                                    ))
    end

    it 'detects suspicious TLD' do
      email = create(:email, sender_email: 'phishing@suspicious.tk')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'sender',
                                      severity: 'high',
                                      description: include('Suspicious sender domain TLD')
                                    ))
    end

    it 'detects IP-based sender domain' do
      email = create(:email, sender_email: 'sender@192.168.1.1')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'sender',
                                      severity: 'critical',
                                      description: include('IP address instead of domain')
                                    ))
    end

    it 'detects brand name mismatch' do
      email = create(:email,
                     sender_name: 'PayPal Security',
                     sender_email: 'security@suspicious.com')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      critical_indicators = indicators.select { |i| i[:severity] == 'critical' }
      expect(critical_indicators).not_to be_empty
      expect(critical_indicators.any? { |i| i[:details] == 'brand-mismatch' }).to be true
    end

    it 'detects domain spoofing with character substitution' do
      email = create(:email, sender_email: 'admin@micr0s0ft.com')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      critical_indicators = indicators.select { |i| i[:severity] == 'critical' }
      expect(critical_indicators).not_to be_empty
      expect(critical_indicators.any? { |i| i[:details] == 'lookalike-domain' }).to be true
    end

    it 'detects excessive numbers in domain' do
      email = create(:email, sender_email: 'user@domain123456.com')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'sender',
                                      severity: 'medium',
                                      description: include('excessive numbers')
                                    ))
    end

    it 'detects generic sender names' do
      %w[admin support noreply service].each do |name|
        email = create(:email, sender_name: name)
        analyzer = described_class.new(email)
        indicators = analyzer.analyze

        expect(indicators).to include(hash_including(
                                        indicator_type: 'sender',
                                        severity: 'medium',
                                        description: include('Generic sender name')
                                      ))
      end
    end

    it 'returns empty array for legitimate sender' do
      email = create(:email,
                     sender_name: 'John Doe',
                     sender_email: 'john.doe@legitimate-company.com')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to be_empty
    end
  end
end
