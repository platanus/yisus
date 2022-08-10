FactoryBot.define do
  factory :customer do
    name { 'MyName' }
    harvest_id { Time.current.to_i }
    bsale_id { Time.current.to_i + 1 }
  end
end
