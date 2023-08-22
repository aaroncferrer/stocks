namespace :stocks do
  desc 'Update stock data'
  task update: :environment do
    stocks = HTTParty.get('https://phisix-api4.appspot.com/stocks.json')

    if stocks.success?
      stocks['stock'].each do |stock_data|
        symbol = stock_data['symbol']

        stock = Stock.find_by(symbol: symbol)
        if stock
          stock.update(stock_data.except('symbol'))
        else
          Stock.create(stock_data)
        end
      end
    else
      Rails.logger.error('Failed to update stock data')
    end
  end
end
