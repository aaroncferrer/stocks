class Transaction < ApplicationRecord
  belongs_to :trader
  belongs_to :stock

  def calculate_total_price
    stock.price_amount * quantity
  end
end
