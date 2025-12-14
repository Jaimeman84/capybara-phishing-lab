# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ThreatScoringEngine do
  let(:email) { create(:email) }

  describe '#calculate' do
    it 'returns 0 for no indicators' do
      engine = described_class.new(email, [])
      expect(engine.calculate).to eq(0)
    end

    it 'calculates score for single low severity URL indicator' do
      indicators = [{ indicator_type: 'url', severity: 'low' }]
      engine = described_class.new(email, indicators)
      expect(engine.calculate).to eq(5)
    end

    it 'calculates score for single critical sender indicator' do
      indicators = [{ indicator_type: 'sender', severity: 'critical' }]
      engine = described_class.new(email, indicators)
      expect(engine.calculate).to eq(30)
    end

    it 'sums scores from multiple indicators' do
      indicators = [
        { indicator_type: 'url', severity: 'high' },
        { indicator_type: 'sender', severity: 'medium' },
        { indicator_type: 'content', severity: 'low' }
      ]
      engine = described_class.new(email, indicators)
      # url high=15 + sender medium=15 + content low=5 = 35
      expect(engine.calculate).to eq(35)
    end

    it 'caps score at 100' do
      indicators = [
        { indicator_type: 'url', severity: 'critical' },
        { indicator_type: 'sender', severity: 'critical' },
        { indicator_type: 'content', severity: 'critical' },
        { indicator_type: 'attachment', severity: 'critical' }
      ]
      engine = described_class.new(email, indicators)
      # Would be 25+30+25+30=110, but capped at 100
      expect(engine.calculate).to eq(100)
    end

    it 'handles unknown indicator types gracefully' do
      indicators = [{ indicator_type: 'unknown', severity: 'critical' }]
      engine = described_class.new(email, indicators)
      expect(engine.calculate).to eq(0)
    end

    it 'handles unknown severities gracefully' do
      indicators = [{ indicator_type: 'url', severity: 'unknown' }]
      engine = described_class.new(email, indicators)
      expect(engine.calculate).to eq(0)
    end

    describe 'weight verification' do
      it 'applies correct weights for URL indicators' do
        expect(described_class.new(email, [{ indicator_type: 'url', severity: 'low' }]).calculate).to eq(5)
        expect(described_class.new(email, [{ indicator_type: 'url', severity: 'medium' }]).calculate).to eq(10)
        expect(described_class.new(email, [{ indicator_type: 'url', severity: 'high' }]).calculate).to eq(15)
        expect(described_class.new(email, [{ indicator_type: 'url', severity: 'critical' }]).calculate).to eq(25)
      end

      it 'applies correct weights for sender indicators' do
        expect(described_class.new(email, [{ indicator_type: 'sender', severity: 'low' }]).calculate).to eq(5)
        expect(described_class.new(email, [{ indicator_type: 'sender', severity: 'medium' }]).calculate).to eq(15)
        expect(described_class.new(email, [{ indicator_type: 'sender', severity: 'high' }]).calculate).to eq(25)
        expect(described_class.new(email, [{ indicator_type: 'sender', severity: 'critical' }]).calculate).to eq(30)
      end

      it 'applies correct weights for content indicators' do
        expect(described_class.new(email, [{ indicator_type: 'content', severity: 'low' }]).calculate).to eq(5)
        expect(described_class.new(email, [{ indicator_type: 'content', severity: 'medium' }]).calculate).to eq(10)
        expect(described_class.new(email, [{ indicator_type: 'content', severity: 'high' }]).calculate).to eq(20)
        expect(described_class.new(email, [{ indicator_type: 'content', severity: 'critical' }]).calculate).to eq(25)
      end

      it 'applies correct weights for attachment indicators' do
        expect(described_class.new(email, [{ indicator_type: 'attachment', severity: 'low' }]).calculate).to eq(5)
        expect(described_class.new(email, [{ indicator_type: 'attachment', severity: 'medium' }]).calculate).to eq(15)
        expect(described_class.new(email, [{ indicator_type: 'attachment', severity: 'high' }]).calculate).to eq(25)
        expect(described_class.new(email, [{ indicator_type: 'attachment', severity: 'critical' }]).calculate).to eq(30)
      end
    end
  end
end
