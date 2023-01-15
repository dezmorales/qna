FactoryBot.define do
  sequence :body do |n|
    "MyText-#{n}"
  end

  factory :answer do
    association :question
    association :user
    body

    trait :invalid do
      body { nil }
    end
  end
end
