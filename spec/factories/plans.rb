FactoryBot.define do
  factory :plan do
    sequence(:name) { |n| "Plan #{n}" }
    description "Cajita mensual"
    price 34_900
    sequence(:sku) { |n| "Plan#{n}34900" }
    association :size
    billing_type "Recurrente"
  end
end
