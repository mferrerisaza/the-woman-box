FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "elkai#{n}@gmail.com" }
    password "123456"
    first_name "Miguel"
    last_name "Ferrer"
    phone "3148509472"

    trait :with_orders do
      after(:create) { |user| create_list(:order, 10, user: user) }
    end

    trait :with_cancelled_orders do
      after(:create) { |user| create_list(:order, 2, user: user, status: "Cancelada") }
    end

    trait :with_active_orders do
      after(:create) { |user| create_list(:order, 1, user: user, status: "Pagada") }
    end
  end
end
