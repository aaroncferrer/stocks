require 'rake'
Rails.application.load_tasks
require 'jwt_auth'

class StocksController < ApplicationController
  skip_before_action :check_auth, only: [:refresh]

  def index
    stocks = Stock.order(:id)
    render json: stocks
  end

  def show
    stock = Stock.find(params[:id])
    render json: stock
  end

  def refresh
    Rake::Task['fetch_stocks:all'].execute
    head :no_content
  end
end
