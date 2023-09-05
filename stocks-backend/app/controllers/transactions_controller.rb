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

  def create
    stock_symbol = params[:stock_symbol]
    quantity = params[:quantity].to_i
    transaction_type = params[:transaction_type]

    stock = Stock.find_by(symbol: stock_symbol)

    if stock.nil?
      render json: { error: 'Stock not found' }, status: :not_found
      return
    end

    if quantity <= 0
      render json: { error: 'Invalid quantity' }, status: :unprocessable_entity
      return
    end

    if transaction_type == 'buy'
      handle_buy_transaction(stock, quantity)
    elsif transaction_type == 'sell'
      handle_sell_transaction(stock, quantity)
    else
      render json: { error: 'Invalid transaction type' }, status: :unprocessable_entity
    end
  end

  private

  def handle_buy_transaction(stock, quantity)
    transaction = @current_user.transactions.new(
      stock: stock,
      action: 'buy',
      quantity: quantity,
      stock_symbol: stock.symbol
    )

    total_price = transaction.calculate_total_price

    if @current_user.balance >= total_price
      @current_user.update_columns(balance: @current_user.balance - total_price)
      transaction.total_price = total_price

      if transaction.save
        portfolio = @current_user.portfolios.find_or_initialize_by(stock: stock)
        portfolio.update_portfolio(stock, quantity)

        render json: { transaction: transaction }, status: :created
      else
        render json: { error: 'Failed to create transaction', details: transaction.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
    end
  end

  def handle_sell_transaction(stock, quantity)
    portfolio = @current_user.portfolios.find_by(stock: stock)

    if portfolio.nil? || portfolio.quantity < quantity
      render json: { error: 'Not enough stocks to sell' }, status: :unprocessable_entity
      return
    end

    transaction = @current_user.transactions.new(
      stock: stock,
      action: 'sell',
      quantity: quantity
    )

    total_price = transaction.calculate_total_price
    
    if transaction.save
      portfolio.update_portfolio(stock, -quantity)
      transaction.total_price = total_price

      if portfolio.quantity <= 0
        portfolio.archive
      end

      portfolio_updated = true

      @current_user.update_columns(balance: @current_user.balance + total_price)
      render json: { transaction: transaction }, status: :created
    else
      render json: { error: 'Failed to create transaction', details: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
