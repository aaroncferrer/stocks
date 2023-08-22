require 'jwt_auth'

class StocksController < ApplicationController
  def index
    # Fetch data from the Phisix API using HTTParty
    response = HTTParty.get('https://phisix-api4.appspot.com/stocks.json')
    
    if response.success?
      stocks = response['stock']
      raw_as_of = response['as_of']
      as_of = Time.parse(raw_as_of).strftime('%Y-%m-%d %H:%M:%S %Z') # Convert and format as_of
      stocks.each { |stock| stock['as_of'] = as_of } # Include formatted as_of for each stock
      render json: stocks
    else
      render json: { error: 'Failed to fetch stock data' }, status: :bad_request
    end
  end

  def show
    # Fetch data from the Phisix API using HTTParty based on symbol
    response = HTTParty.get("https://phisix-api4.appspot.com/stocks/#{params[:symbol]}.json")

    if response.success?
      stock = response['stock'].first
      stock['as_of'] = response['as_of']
      render json: stock
    else
      render json: { error: 'Stock not found in external API' }, status: :not_found
    end
  end
end
