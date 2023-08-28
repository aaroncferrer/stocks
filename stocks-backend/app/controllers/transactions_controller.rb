require 'jwt_auth'

class TransactionsController < ApplicationController
  def index
    if @current_user.is_a?(Admin)
      transactions = Transaction.includes(:trader, :stock)
    else
      transactions = @current_user.transactions.includes(:stock)
    end
    render json: transactions, include: [:trader, :stock]
  end

  def buy
    stock_symbol = params[:stock_symbol]
    quantity = params[:quantity].to_i

    stock = Stock.find_by(symbol: stock_symbol)
    if stock.nil?
      render json: { error: 'Stock not found' }, status: :not_found
      return
    end

    total_price = stock.price_amount * quantity

    transaction = @current_user.transactions.new(
      stock: stock,
      action: 'buy',
      quantity: quantity,
      total_price: total_price,
			stock_symbol: stock_symbol
    )

    if transaction.save
      update_portfolio(stock, quantity)
      render json: { transaction: transaction }, status: :created
    else
      render json: { error: 'Failed to create transaction', details: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def sell
    stock_symbol = params[:stock_symbol]
    quantity = params[:quantity].to_i 

    stock = Stock.find_by(symbol:stock_symbol)
    if stock.nil?
      render json: { error: 'Stock not found' }, status: :not_found
      return
    end

    portfolio = @current_user.portfolios.find_by(stock: stock)
    if portfolio.nil? || portfolio.quantity < quantity
      render json: { error: 'Not enough stocks to sell' }, status: :unprocessable_entity
      return
    end

    total_price = stock.price_amount * quantity

    transaction = @current_user.transactions.new(
      stock: stock,
      action: 'sell',
      quantity: quantity,
      total_price: total_price
    )

    if transaction.save
      update_portfolio(stock, -quantity)
      render json: { transaction: transaction }, status: :created
    else
      render json: { error: 'Failed to create transaction', details: transaction.error.full_messages }, status: :unprocessable_entity
    end
  end

	private

	def update_portfolio(stock, quantity)
		portfolio = @current_user.portfolios.find_or_initialize_by(stock: stock)

		if portfolio.new_record?
			portfolio.stock_symbol = stock.symbol
			portfolio.quantity = quantity
			portfolio.current_price = stock.price_amount
			portfolio.total_amount = quantity * stock.price_amount
		else
			portfolio.quantity += quantity
			portfolio.current_price = stock.price_amount
			portfolio.total_amount = portfolio.quantity * stock.price_amount
		end

		portfolio.save
	end

end
