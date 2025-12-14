# frozen_string_literal: true

FactoryBot.define do
  factory :email do
    sender_name { Faker::Name.name }
    sender_email { Faker::Internet.email }
    recipient_email { 'user@company.com' }
    subject { Faker::Lorem.sentence }
    body_plain { Faker::Lorem.paragraph(sentence_count: 5) }
    received_at { Time.current }

    trait :phishing do
      sender_name { 'PayPal Security' }
      sender_email { 'security@paypa1.suspicious.com' }
      subject { 'URGENT: Verify your account immediately' }
      body_plain { 'Click here to verify: http://bit.ly/fake-link or your account will be suspended!' }
    end

    trait :legitimate do
      sender_name { 'John Doe' }
      sender_email { 'john.doe@legitimate-company.com' }
      subject { 'Meeting notes from today' }
      body_plain { 'Here are the notes from our meeting. Please review and let me know if you have any questions.' }
    end

    trait :reported do
      after(:create) do |email|
        create(:report, email: email)
      end
    end

    trait :with_indicators do
      after(:create) do |email|
        create_list(:phishing_indicator, 3, email: email)
      end
    end

    trait :with_threat_score do
      after(:create) do |email|
        create(:threat_score, email: email)
      end
    end
  end
end
