# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:email) }
  end

  describe 'validations' do
    subject { create(:report) }

    it { is_expected.to validate_uniqueness_of(:email_id) }
    it { is_expected.to validate_presence_of(:reported_at) }
  end

  describe 'callbacks' do
    describe '#set_reported_at' do
      it 'sets reported_at on create when nil' do
        email = create(:email)
        report = described_class.new(email: email)
        expect(report.reported_at).to be_nil
        report.save!
        expect(report.reported_at).to be_present
        expect(report.reported_at).to be_within(1.second).of(Time.current)
      end

      it 'does not override reported_at if already set' do
        email = create(:email)
        custom_time = 2.days.ago
        report = described_class.create!(email: email, reported_at: custom_time)
        expect(report.reported_at).to be_within(1.second).of(custom_time)
      end
    end
  end

  describe 'email uniqueness' do
    it 'allows only one report per email' do
      email = create(:email)
      create(:report, email: email)
      duplicate_report = build(:report, email: email)
      expect(duplicate_report).not_to be_valid
      expect(duplicate_report.errors[:email_id]).to be_present
    end
  end
end
