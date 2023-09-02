require 'rails_helper'
require 'jwt_auth'

RSpec.describe "Transactions", type: :request do
  before(:each) do
    @trader = FactoryBot.create(:trader, balance: 500) # Assuming an initial balance of $1000
    @token = JwtAuth.encode({ trader_id: @trader.id })
  end

  describe "GET /transactions" do
    it "returns a list of transactions for the trader" do
      FactoryBot.create_list(:transaction, 3, trader: @trader)
      get '/transactions', headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      transactions = JSON.parse(response.body)
      expect(transactions.length).to eq(3)
    end

    it "returns a list of transactions for an admin user" do
      admin = FactoryBot.create(:admin)
      admin_token = JwtAuth.encode({ admin_id: admin.id })
      FactoryBot.create_list(:transaction, 3)
      get '/transactions', headers: { "Authorization" => "Bearer #{admin_token}" }

      expect(response).to have_http_status(200)
      transactions = JSON.parse(response.body)
      expect(transactions.length).to eq(3)
    end
  end

  describe "POST /transactions/buy" do
    it "allows the trader to buy stocks" do
      stock = FactoryBot.create(:stock, price_amount: 50.0) 
      buy_params = { stock_symbol: stock.symbol, quantity: 2 }
      post '/buy', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)["transaction"]["action"]).to eq("buy")
      expect(@trader.reload.balance).to eq(400.0) 
    end

    it "doesn't allow the trader to buy because stock is not found" do
      stock = FactoryBot.create(:stock, price_amount: 50.0) 
      buy_params = { stock_symbol: "FAKE", quantity: 2 }
      post '/buy', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["error"]).to include("Stock not found")
      expect(@trader.reload.balance).to eq(500.0)
    end

    it "doesn't allow the trader to buy stocks due to insufficient balance" do
      stock = FactoryBot.create(:stock, price_amount: 50.0) 
      buy_params = { stock_symbol: stock.symbol, quantity: 11 }
      post '/buy', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      puts response.body
      expect(JSON.parse(response.body)["error"]).to include("Insufficient balance")
      expect(@trader.reload.balance).to eq(500.0) 
    end

  end

  describe "POST /transactions/sell" do
    it "allows the trader to sell stocks" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2 }
      post '/buy', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      sell_params = { stock_symbol: stock.symbol, quantity: 1 }
      post '/sell', params: sell_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)["transaction"]["action"]).to eq("sell")
      expect(@trader.reload.balance).to eq(450.0) 
    end

    it "doesn't allow the trader to sell stocks" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2 }
      post '/buy', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      sell_params = { stock_symbol: stock.symbol, quantity: 3 }
      post '/sell', params: sell_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to include("Not enough stocks to sell")
      expect(@trader.reload.balance).to eq(400.0) 
    end

    it "doesn't allow the trader to sell because stock is not found" do
      stock = FactoryBot.create(:stock, price_amount: 50.0) 
      buy_params = { stock_symbol: "FAKE", quantity: 2 }
      post '/sell', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["error"]).to include("Stock not found")
      expect(@trader.reload.balance).to eq(500.0)
    end

  end
end