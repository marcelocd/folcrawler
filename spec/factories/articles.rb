require 'factory_bot'

FactoryBot.define do
  factory :article do
    source { Article.sources.keys.sample }
    title { Faker::Lorem.sentence }
    url { Faker::Internet.url }
    collected_at { Faker::Date.backward(days: 14) }
    body { Faker::Lorem.paragraph }
  end
end
