# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThreatScore, type: :model do
  describe 'associations' do
    it { should belong_to(:email) }
  end

  describe 'validations' do
    subject { create(:threat_score) }

    it { should validate_uniqueness_of(:email_id) }
    it { should validate_presence_of(:score) }
    it { should validate_presence_of(:calculated_at) }
    it { should validate_numericality_of(:score).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }

    it 'allows valid risk levels' do
      email = create(:email)
      ThreatScore::RISK_LEVELS.each do |level|
        ThreatScore.where(email: email).destroy_all
        threat_score = build(:threat_score, email: email, score: 50, risk_level: level)
        expect(threat_score).to be_valid
      end
    end
  end

  describe 'callbacks' do
    describe '#set_calculated_at' do
      it 'sets calculated_at on create when nil' do
        email = create(:email)
        threat_score = ThreatScore.new(email: email, score: 50)
        expect(threat_score.calculated_at).to be_nil
        threat_score.save!
        expect(threat_score.calculated_at).to be_present
        expect(threat_score.calculated_at).to be_within(1.second).of(Time.current)
      end

      it 'does not override calculated_at if already set' do
        email = create(:email)
        custom_time = 2.days.ago
        threat_score = ThreatScore.create!(email: email, score: 50, calculated_at: custom_time)
        expect(threat_score.calculated_at).to be_within(1.second).of(custom_time)
      end
    end

    describe '#set_risk_level_from_score' do
      it 'sets risk_level to low for scores 0-25' do
        email = create(:email)
        threat_score = ThreatScore.create!(email: email, score: 20)
        expect(threat_score.risk_level).to eq('low')
      end

      it 'sets risk_level to medium for scores 26-50' do
        email = create(:email)
        threat_score = ThreatScore.create!(email: email, score: 40)
        expect(threat_score.risk_level).to eq('medium')
      end

      it 'sets risk_level to high for scores 51-75' do
        email = create(:email)
        threat_score = ThreatScore.create!(email: email, score: 65)
        expect(threat_score.risk_level).to eq('high')
      end

      it 'sets risk_level to critical for scores 76-100' do
        email = create(:email)
        threat_score = ThreatScore.create!(email: email, score: 90)
        expect(threat_score.risk_level).to eq('critical')
      end

      it 'handles boundary values correctly' do
        expect(ThreatScore.create!(email: create(:email), score: 0).risk_level).to eq('low')
        expect(ThreatScore.create!(email: create(:email), score: 25).risk_level).to eq('low')
        expect(ThreatScore.create!(email: create(:email), score: 26).risk_level).to eq('medium')
        expect(ThreatScore.create!(email: create(:email), score: 50).risk_level).to eq('medium')
        expect(ThreatScore.create!(email: create(:email), score: 51).risk_level).to eq('high')
        expect(ThreatScore.create!(email: create(:email), score: 75).risk_level).to eq('high')
        expect(ThreatScore.create!(email: create(:email), score: 76).risk_level).to eq('critical')
        expect(ThreatScore.create!(email: create(:email), score: 100).risk_level).to eq('critical')
      end
    end
  end

  describe 'scopes' do
    let!(:low_score) { create(:threat_score, :low_risk) }
    let!(:medium_score) { create(:threat_score, :medium_risk) }
    let!(:high_score) { create(:threat_score, :high_risk) }
    let!(:critical_score) { create(:threat_score, :critical_risk) }

    describe '.low_risk' do
      it 'returns only low risk scores' do
        expect(ThreatScore.low_risk).to include(low_score)
        expect(ThreatScore.low_risk).not_to include(medium_score, high_score, critical_score)
      end
    end

    describe '.medium_risk' do
      it 'returns only medium risk scores' do
        medium_results = ThreatScore.medium_risk
        expect(medium_results).to include(medium_score)
        expect(medium_results.pluck(:risk_level).uniq).to eq(['medium'])
      end
    end

    describe '.high_risk' do
      it 'returns only high risk scores' do
        high_results = ThreatScore.high_risk
        expect(high_results).to include(high_score)
        expect(high_results.pluck(:risk_level).uniq).to eq(['high'])
      end
    end

    describe '.critical_risk' do
      it 'returns only critical risk scores' do
        critical_results = ThreatScore.critical_risk
        expect(critical_results).to include(critical_score)
        expect(critical_results.pluck(:risk_level).uniq).to eq(['critical'])
      end
    end

    describe '.by_risk' do
      it 'filters scores by risk level' do
        expect(ThreatScore.by_risk('low')).to include(low_score)
        expect(ThreatScore.by_risk('low')).not_to include(high_score)
      end
    end
  end

  describe 'email uniqueness' do
    it 'allows only one threat score per email' do
      email = create(:email)
      create(:threat_score, email: email)
      duplicate_score = build(:threat_score, email: email)
      expect(duplicate_score).not_to be_valid
      expect(duplicate_score.errors[:email_id]).to be_present
    end
  end
end
