namespace :fetch_stocks do
  desc 'Fetch stocks from the API and save to the database'
  task :all => :environment do
    puts "Fetching stocks task started at #{Time.now}"
    response = HTTParty.get('https://phisix-api4.appspot.com/stocks.json')

    if response.success?
      stocks = response['stock']

      stocks.each do |stock_data|
        stock = Stock.find_or_initialize_by(symbol: stock_data['symbol'])
        stock.update(
            name: stock_data['name'],
            symbol: stock_data['symbol'],
            price_amount: stock_data['price']['amount'],
            price_currency: stock_data['price']['currency'],
            percent_change: stock_data['percent_change'],
            volume: stock_data['volume'],
            as_of: Time.current
        )
      end
      puts "Stocks fetched and saved successfully at #{Time.now}"
    else
      puts "Failed to fetch stock data."
    end
  end
end
