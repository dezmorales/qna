FactoryBot.define do
  factory :answer do
    body { "My text" }

    trait :invalid do
      body { nil }
    end
  end
end
