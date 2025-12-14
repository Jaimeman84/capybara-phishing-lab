# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhishingIndicator, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:email) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:indicator_type) }
    it { is_expected.to validate_presence_of(:severity) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }

    it 'validates indicator_type inclusion' do
      email = create(:email)
      indicator = build(:phishing_indicator, email: email, indicator_type: 'invalid')
      expect(indicator).not_to be_valid
      expect(indicator.errors[:indicator_type]).to be_present
    end

    it 'allows valid indicator types' do
      email = create(:email)
      PhishingIndicator::INDICATOR_TYPES.each do |type|
        indicator = build(:phishing_indicator, email: email, indicator_type: type)
        expect(indicator).to be_valid
      end
    end

    it 'validates severity inclusion' do
      email = create(:email)
      indicator = build(:phishing_indicator, email: email, severity: 'invalid')
      expect(indicator).not_to be_valid
      expect(indicator.errors[:severity]).to be_present
    end

    it 'allows valid severities' do
      email = create(:email)
      PhishingIndicator::SEVERITIES.each do |severity|
        indicator = build(:phishing_indicator, email: email, severity: severity)
        expect(indicator).to be_valid
      end
    end
  end

  describe 'scopes' do
    let(:email) { create(:email) }
    let!(:url_indicator) { create(:phishing_indicator, email: email, indicator_type: 'url') }
    let!(:sender_indicator) { create(:phishing_indicator, email: email, indicator_type: 'sender') }
    let!(:low_indicator) { create(:phishing_indicator, :low, email: email) }
    let!(:medium_indicator) { create(:phishing_indicator, :medium, email: email) }
    let!(:high_indicator) { create(:phishing_indicator, :high, email: email) }
    let!(:critical_indicator) { create(:phishing_indicator, :critical, email: email) }

    describe '.by_type' do
      it 'filters indicators by type' do
        expect(described_class.by_type('url')).to include(url_indicator)
        expect(described_class.by_type('url')).not_to include(sender_indicator)
      end
    end

    describe '.by_severity' do
      it 'filters indicators by severity' do
        expect(described_class.by_severity('low')).to include(low_indicator)
        expect(described_class.by_severity('low')).not_to include(high_indicator)
      end
    end

    describe '.high_severity' do
      it 'returns only high and critical indicators' do
        high_severity = described_class.high_severity
        expect(high_severity).to include(high_indicator, critical_indicator)
        expect(high_severity).not_to include(low_indicator, medium_indicator)
      end
    end
  end
end
