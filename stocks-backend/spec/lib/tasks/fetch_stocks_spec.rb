require 'rails_helper'
require 'rake'

Rake.application.load_rakefile

describe 'fetch_stocks:all' do
  before do
    Rake::Task['fetch_stocks:all'].reenable
  end

  it 'fetches and updates stock data' do
    VCR.use_cassette('stock_data') do
      expect { Rake::Task['fetch_stocks:all'].invoke }.to output(/Stocks fetched and saved successfully/).to_stdout
    end
  end

  it 'handles API fetch failure' do
    # Stub HTTP request to simulate failure
    allow(HTTParty).to receive(:get).and_return(double('response', success?: false))

    expect { Rake::Task['fetch_stocks:all'].invoke }.to output(/Failed to fetch stock data/).to_stdout
  end
end
