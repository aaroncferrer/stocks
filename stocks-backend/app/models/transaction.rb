class Transaction < ApplicationRecord
  belongs_to :trader
  belongs_to :stock, foreign_key: 'stock_symbol', primary_key: 'symbol'
end
