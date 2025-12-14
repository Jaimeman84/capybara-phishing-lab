# frozen_string_literal: true

FactoryBot.define do
  factory :phishing_indicator do
    association :email
    indicator_type { %w[url sender content attachment].sample }
    severity { %w[low medium high critical].sample }
    description { Faker::Lorem.sentence }
    details { Faker::Lorem.word }

    trait :critical do
      severity { 'critical' }
      indicator_type { 'url' }
      description { 'Known malicious URL detected' }
      details { 'http://malicious-site.com' }
    end

    trait :high do
      severity { 'high' }
      indicator_type { 'sender' }
      description { 'Suspicious sender domain' }
      details { 'phishing@suspicious.com' }
    end

    trait :medium do
      severity { 'medium' }
      indicator_type { 'content' }
      description { 'Urgency language detected' }
      details { 'urgent' }
    end

    trait :low do
      severity { 'low' }
      indicator_type { 'sender' }
      description { 'Free email provider' }
      details { 'gmail.com' }
    end
  end
end
