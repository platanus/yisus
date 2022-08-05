FactoryBot.define do
  factory :project do
    name { "MyString" }
    harvest_id { 1 }
    unit_price { 1.5 }
    customer
  end
end
