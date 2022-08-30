FactoryBot.define do
  factory :customer do
    name { 'MyName' }
    sequence(:harvest_id) { |n| n }
    sequence(:bsale_id) { |n| n }
  end
end
