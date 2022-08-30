FactoryBot.define do
  factory :document do
    sequence(:bsale_id) { |n| n }
    url { "MyString" }
    time_report
  end
end
