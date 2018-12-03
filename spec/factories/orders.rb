FactoryBot.define do
  factory :order do
    status "Incompleta"
    amount 34_900
    association :user
    plan_sku "Plan 1"
    last_period "2018-11-11"
    address "Calle 11a 42-18"
    city "Medellín"
    province "Antioquia"
    country "Colombia"
    address_aditional_info "Edificio el recinto apto 302"
  end
end
