class Stock < ApplicationRecord
    self.primary_key = 'symbol'

    has_many :transactions, foreign_key: 'stock_symbol', primary_key: 'symbol'
    has_many :portfolios, foreign_key: 'stock_symbol', primary_key: 'symbol'
    has_many :traders, through: :transactions
end
