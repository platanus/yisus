FactoryBot.define do
  factory :project do
    name { "MyString" }
    harvest_id { Time.current.to_i }
    unit_price { 1.5 }
    customer
  end
end
