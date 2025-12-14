# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhishingDetection::AttachmentAnalyzer do
  describe '#analyze' do
    it 'detects attachment mentions' do
      email = create(:email, body_plain: 'Please see the attached document')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'attachment',
                                      severity: 'low',
                                      description: include('Attachment-related content detected')
                                    ))
    end

    it 'detects dangerous file extensions with critical severity' do
      %w[.exe .scr .bat].each do |ext|
        email = create(:email, body_plain: "Download this file#{ext}")
        analyzer = described_class.new(email)
        indicators = analyzer.analyze

        expect(indicators).to include(hash_including(
                                        indicator_type: 'attachment',
                                        severity: 'critical',
                                        description: include('Attachment-related content')
                                      ))
      end
    end

    it 'detects safe file extensions with low severity' do
      email = create(:email, body_plain: 'Here is the PDF document')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(
                                      indicator_type: 'attachment',
                                      severity: 'low'
                                    ))
    end

    it 'checks both subject and body' do
      email = create(:email,
                     subject: 'Download attachment',
                     body_plain: 'Click to download')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).not_to be_empty
    end

    it 'stops after first match to avoid duplicates' do
      email = create(:email, body_plain: 'attachment file download document')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators.length).to eq(1)
    end

    it 'returns empty array when no attachment keywords present' do
      email = create(:email, body_plain: 'This is a simple text message')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to be_empty
    end

    it 'is case insensitive' do
      email = create(:email, body_plain: 'DOWNLOAD THE ATTACHMENT.EXE')
      analyzer = described_class.new(email)
      indicators = analyzer.analyze

      expect(indicators).to include(hash_including(severity: 'critical'))
    end
  end
end
