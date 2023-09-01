require 'rails_helper'
require 'jwt_auth'

RSpec.describe "Stocks", type: :request do
  before(:each) do
    @trader = FactoryBot.create(:trader)
    @token = JwtAuth.encode({ trader_id: @trader.id })
  end

  describe "GET /stocks" do
    it "returns a list of stocks" do
      FactoryBot.create_list(:stock, 3)
      get '/stocks', headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      stocks = JSON.parse(response.body)
      expect(stocks.length).to eq(3)
    end
  end

  describe "GET /stocks/:id" do
    it "returns a single stock" do
      stock = FactoryBot.create(:stock)
      get "/stocks/#{stock.id}", headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      parsed_stock = JSON.parse(response.body)
      expect(parsed_stock["id"]).to eq(stock.id)
    end
  end

  describe "GET /stocks/refresh" do
    it "triggers the stock data refresh" do
      expect(Rake::Task['fetch_stocks:all']).to receive(:execute)
      post '/refresh_stocks', headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(204)
    end
  end
end
