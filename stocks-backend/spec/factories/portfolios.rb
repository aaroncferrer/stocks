FactoryBot.define do
  factory :portfolio do
    trader
    stock
    quantity { 2 }
    current_price { 140.0 }
    total_amount { 280.0 }
    stock_symbol { 'BDO' }
  end
end