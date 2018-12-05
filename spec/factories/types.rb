FactoryBot.define do
  factory :type do
    name "Toallas"

    trait :with_sizes do
      after(:create) { |type| create_list(:size, 5, type: type) }
    end
  end
end
