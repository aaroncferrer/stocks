FactoryBot.define do
  factory :transaction do
    trader
    stock
    action { 'buy' }
    quantity { 3 }
    total_price { 420.29999999999995 }
    stock_symbol { 'BDO' }
  end
end