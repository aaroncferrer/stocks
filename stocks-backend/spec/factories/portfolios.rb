FactoryBot.define do
  factory :portfolio do
    trader
    stock
    quantity { 9 }
    current_price { 7.0 }
    total_amount { 63.0 }
    stock_symbol { 'NXGEN' }
  end
end