require 'jwt_auth'

class StocksController < ApplicationController
  def index
    stocks = Stock.order(:id)
    render json: stocks
  end

  def show
    stock = Stock.find_by(symbol: params[:symbol])
    render json: stock
  end
end
