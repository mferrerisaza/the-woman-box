FactoryBot.define do
  factory :size do
    sequence(:name) { |n| "Tamaño #{n}" }
    association :type

    trait :with_plans do
      after(:create) { |size| create_list(:plan, 10, size: size) }
    end
  end
end
