FactoryBot.define do
  factory :document do
    bsale_id { Time.current.to_i }
    url { "MyString" }
    time_report
  end
end
