class Portfolio < ApplicationRecord
  belongs_to :trader
  belongs_to :stock
  
  scope :active, -> { where(archived: false) }

  def archive
    update(archived: true)
  end

  def update_portfolio(stock, quantity)
		if new_record?
			self.stock_symbol = stock.symbol
			self.quantity = quantity
			self.current_price = stock.price_amount
			self.total_amount = quantity * stock.price_amount
		else
			self.quantity += quantity
			self.current_price = stock.price_amount
			self.total_amount = self.quantity * stock.price_amount
		end

		save
	end

end
