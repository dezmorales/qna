FactoryBot.define do
  sequence :url do |n|
    "http://MyString-#{n}.com"
  end

  factory :link do
    name { "My link" }
    url { "https://www.google.com" }
  end
end
