require 'jwt_auth'

class TradersController < ApplicationController
  def buy_stock
    stock_symbol = params[:symbol]

    response = HTTParty.get("https://phisix-api4.appspot.com/stocks/#{stock_symbol}.json")

    if response.success?
      stock_data = response['stock'].first
      current_price = stock_data['price']['amount']

      total_price = current_price * params[:quantity].to_i

      if @current_user.portfolios.exists?(stock_symbol: stock_symbol)
        portfolio = @current_user.portfolios.find_by(stock_symbol: stock_symbol)
        portfolio.quantity += params[:quantity].to_i
        portfolio.current_price = current_price
        portfolio.total_amount = portfolio.quantity * current_price
        portfolio.save
      else
        portfolio = @current_user.portfolios.create(
          stock_symbol: stock_symbol,
          quantity: params[:quantity].to_i,
          current_price: current_price,
          total_amount: total_price
        )
      end

      transaction = @current_user.transactions.new(
        action: 'buy',
        quantity: params[:quantity].to_i,
        total_price: total_price,
        stock_symbol: stock_symbol
      )

      if portfolio.save && transaction.save
        render json: { transaction: transaction, portfolio: portfolio }, status: :created
      else
        render json: { error: 'Failed to create transaction or portfolio', details: { portfolio_errors: portfolio.errors.full_messages, transaction_errors: transaction.errors.full_messages } }, status: :unprocessable_entity
      end

    else
      render json: { error: 'Stock not found in external API' }, status: :not_found
    end
  end
end
