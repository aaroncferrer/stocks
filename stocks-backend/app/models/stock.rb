class Stock < ApplicationRecord
    has_many :transactions
    has_many :portfolios
    has_many :traders, through: :transactions
end
