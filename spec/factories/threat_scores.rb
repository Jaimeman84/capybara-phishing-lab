# frozen_string_literal: true

FactoryBot.define do
  factory :threat_score do
    association :email
    score { 50 }

    trait :low_risk do
      score { rand(0..25) }
    end

    trait :medium_risk do
      score { rand(26..50) }
    end

    trait :high_risk do
      score { rand(51..75) }
    end

    trait :critical_risk do
      score { rand(76..100) }
    end
  end
end
