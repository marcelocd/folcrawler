require 'factory_bot'

FactoryBot.define do
  factory :article do
    source { Faker::Lorem.word }
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    published_at { Faker::Date.backward(days: 15)
                              .to_s }
    collected_at { Faker::Date.backward(days: 14) }
    body { Faker::Lorem.paragraph }
  end
end
