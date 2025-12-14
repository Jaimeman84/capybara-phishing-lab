# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Email, type: :model do
  describe 'associations' do
    it { should have_one(:report).dependent(:destroy) }
    it { should have_many(:phishing_indicators).dependent(:destroy) }
    it { should have_one(:threat_score).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:sender_email) }
    it { should validate_presence_of(:sender_name) }
    it { should validate_presence_of(:recipient_email) }
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:body_plain) }
    it { should validate_presence_of(:received_at) }
    it { should validate_length_of(:subject).is_at_most(200) }

    it 'validates sender_email format' do
      email = build(:email, sender_email: 'invalid-email')
      expect(email).not_to be_valid
      expect(email.errors[:sender_email]).to be_present
    end

    it 'validates recipient_email format' do
      email = build(:email, recipient_email: 'invalid-email')
      expect(email).not_to be_valid
      expect(email.errors[:recipient_email]).to be_present
    end

    it 'validates phishing_type inclusion' do
      email = build(:email, phishing_type: 'invalid_type')
      expect(email).not_to be_valid
      expect(email.errors[:phishing_type]).to be_present
    end

    it 'allows valid phishing types' do
      Email::PHISHING_TYPES.each do |type|
        email = build(:email, phishing_type: type)
        expect(email).to be_valid
      end
    end

    it 'allows nil phishing_type' do
      email = build(:email, phishing_type: nil)
      expect(email).to be_valid
    end
  end

  describe 'scopes' do
    let!(:old_email) { create(:email, received_at: 2.days.ago) }
    let!(:new_email) { create(:email, received_at: 1.day.ago) }
    let!(:phishing_email) { create(:email, is_phishing: true) }
    let!(:legitimate_email) { create(:email, is_phishing: false) }
    let!(:reported_email) { create(:email, :reported) }

    describe '.recent' do
      it 'orders emails by received_at descending' do
        recent_emails = Email.recent.to_a
        expect(recent_emails).to include(new_email, old_email)
        expect(recent_emails.index(new_email)).to be < recent_emails.index(old_email)
      end
    end

    describe '.phishing' do
      it 'returns only phishing emails' do
        expect(Email.phishing).to include(phishing_email)
        expect(Email.phishing).not_to include(legitimate_email)
      end
    end

    describe '.legitimate' do
      it 'returns only legitimate emails' do
        expect(Email.legitimate).to include(legitimate_email)
        expect(Email.legitimate).not_to include(phishing_email)
      end
    end

    describe '.reported' do
      it 'returns only reported emails' do
        expect(Email.reported).to include(reported_email)
        expect(Email.reported).not_to include(phishing_email)
      end
    end

    describe '.with_associations' do
      it 'eager loads associations' do
        emails = Email.with_associations
        expect(emails).to be_a(ActiveRecord::Relation)
      end
    end
  end

  describe '#reported?' do
    it 'returns true when email has a report' do
      email = create(:email, :reported)
      expect(email.reported?).to be true
    end

    it 'returns false when email has no report' do
      email = create(:email)
      expect(email.reported?).to be false
    end
  end

  describe '#analyzed?' do
    it 'returns true when email has a threat score' do
      email = create(:email, :with_threat_score)
      expect(email.analyzed?).to be true
    end

    it 'returns false when email has no threat score' do
      email = create(:email)
      expect(email.analyzed?).to be false
    end
  end

  describe '#risk_level' do
    it 'returns threat score risk level when present' do
      email = create(:email)
      create(:threat_score, email: email, score: 65)
      expect(email.risk_level).to eq('high')
    end

    it 'returns unknown when no threat score exists' do
      email = create(:email)
      expect(email.risk_level).to eq('unknown')
    end
  end
end
