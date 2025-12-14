# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhishingDetection::ContentAnalyzer do
  describe '#analyze' do
    it 'detects urgency language' do
      PhishingDetection::ContentAnalyzer::URGENCY_KEYWORDS.each do |keyword|
        email = create(:email, body_plain: "Please #{keyword} immediately")
        analyzer = described_class.new(email)
        indicators = analyzer.analyze

        expect(indicators).to include(hash_including(
                                        indicator_type: 'content',
                                        severity: 'medium',
                                        description: include('Urgency language detected')
                                      ))
      end
    end

    it 'detects credential requests' do
      email = create(:email, body_plain: 'Please verify your password')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'content',
                                      severity: 'high',
                                      description: include('Credential request detected')
                                    ))
    end

    it 'detects generic greetings' do
      email = create(:email, body_plain: 'Dear Customer, your account needs attention')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'content',
                                      severity: 'low',
                                      description: include('Generic greeting detected')
                                    ))
    end

    it 'checks both subject and body' do
      email = create(:email,
                     subject: 'URGENT action required',
                     body_plain: 'Please verify your account')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators.length).to be >= 2
      expect(indicators).to include(hash_including(description: include('Urgency')))
      expect(indicators).to include(hash_including(description: include('Credential')))
    end

    it 'is case insensitive' do
      email = create(:email, body_plain: 'URGENT: VERIFY YOUR PASSWORD')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators.length).to be >= 2
    end

    it 'returns empty array for neutral content' do
      email = create(:email,
                     subject: 'Meeting notes',
                     body_plain: 'Here are the notes from our meeting today.')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to be_empty
    end

    it 'stops after first credential keyword to avoid duplicates' do
      email = create(:email, body_plain: 'Update your password and username')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      credential_indicators = indicators.select { |i| i[:description].include?('Credential') }
      expect(credential_indicators.length).to eq(1)
    end
  end
end
