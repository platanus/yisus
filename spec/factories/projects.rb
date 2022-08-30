FactoryBot.define do
  factory :project do
    name { "MyString" }
    sequence(:harvest_id) { |n| n }
    unit_price { 1.5 }
    customer
  end
end
