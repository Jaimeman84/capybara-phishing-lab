# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    association :email
    reported_at { Time.current }
  end
end
