# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhishingDetectionService do
  let(:email) { create(:email, :phishing) }
  let(:service) { described_class.new(email) }

  describe '#analyze' do
    it 'returns a hash with indicators and threat_score' do
      result = service.analyze
      expect(result).to have_key(:indicators)
      expect(result).to have_key(:threat_score)
    end

    it 'creates phishing indicators for the email' do
      expect { service.analyze }.to change { email.phishing_indicators.count }.from(0)
    end

    it 'creates a threat score for the email' do
      expect { service.analyze }.to change { email.threat_score }.from(nil)
    end

    it 'runs all analyzers' do
      url_analyzer = instance_double(PhishingDetection::UrlAnalyzer)
      sender_analyzer = instance_double(PhishingDetection::SenderAnalyzer)
      content_analyzer = instance_double(PhishingDetection::ContentAnalyzer)
      attachment_analyzer = instance_double(PhishingDetection::AttachmentAnalyzer)

      allow(PhishingDetection::UrlAnalyzer).to receive(:new).and_return(url_analyzer)
      allow(PhishingDetection::SenderAnalyzer).to receive(:new).and_return(sender_analyzer)
      allow(PhishingDetection::ContentAnalyzer).to receive(:new).and_return(content_analyzer)
      allow(PhishingDetection::AttachmentAnalyzer).to receive(:new).and_return(attachment_analyzer)

      allow(url_analyzer).to receive(:analyze).and_return([])
      allow(sender_analyzer).to receive(:analyze).and_return([])
      allow(content_analyzer).to receive(:analyze).and_return([])
      allow(attachment_analyzer).to receive(:analyze).and_return([])

      service.analyze

      expect(url_analyzer).to have_received(:analyze)
      expect(sender_analyzer).to have_received(:analyze)
      expect(content_analyzer).to have_received(:analyze)
      expect(attachment_analyzer).to have_received(:analyze)
    end

    it 'calculates threat score based on indicators' do
      result = service.analyze
      expect(result[:threat_score]).to be_a(Integer)
      expect(result[:threat_score]).to be_between(0, 100)
    end

    it 'saves threat score with calculated_at timestamp' do
      service.analyze
      email.reload
      expect(email.threat_score.calculated_at).to be_within(1.second).of(Time.current)
    end
  end

  describe 'integration with real analyzers' do
    it 'detects phishing indicators from phishing email' do
      phishing_email = create(:email,
                              sender_email: 'phishing@suspicious.tk',
                              subject: 'URGENT: Verify your password',
                              body_plain: 'Click here: http://bit.ly/fake')

      result = PhishingDetectionService.new(phishing_email).analyze

      expect(result[:indicators]).not_to be_empty
      expect(result[:threat_score]).to be > 30
    end

    it 'detects fewer indicators from legitimate email' do
      legitimate_email = create(:email,
                                sender_email: 'colleague@company.com',
                                subject: 'Meeting notes',
                                body_plain: 'Here are the notes from our meeting.')

      result = PhishingDetectionService.new(legitimate_email).analyze

      expect(result[:threat_score]).to be < 50
    end
  end
end
