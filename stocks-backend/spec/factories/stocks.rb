FactoryBot.define do
  factory :stock do
    sequence(:name) { |n| "Stock Name #{n}" }
    sequence(:symbol) { |n| "SYM#{n}" }
    price_currency { "PHP" }
    price_amount { 140.0 }
    percent_change { -2.59 }
    volume { 3815320 }
    as_of { "2023-08-31T19:42:05.436+08:00" }
    created_at { "2023-08-29T21:09:57.571+08:00" }
    updated_at { "2023-08-31T19:42:05.437+08:00" }
  end
end