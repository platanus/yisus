FactoryBot.define do
  factory :time_report do
    from { "2022-08-10" }
    to { "2022-08-10" }
    billable_hours { 1.5 }
    project
  end
end
