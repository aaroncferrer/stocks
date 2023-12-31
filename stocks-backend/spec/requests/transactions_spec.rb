require 'rails_helper'
require 'jwt_auth'

RSpec.describe "Transactions", type: :request do
  before(:each) do
    @trader = FactoryBot.create(:trader, balance: 500) 
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

  describe "BUY: POST /transactions" do
    it "doesn't allow the trader to buy stocks due to invalid transaction" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'invalid' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to include("Invalid transaction type")
      expect(@trader.reload.balance).to eq(500.0)
    end

    it "allows the trader to buy stocks" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)["transaction"]["action"]).to eq("buy")
      expect(@trader.reload.balance).to eq(400.0)
    end

    it "doesn't allow the trader to buy because stock is not found" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: "FAKE", quantity: 2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["error"]).to include("Stock not found")
      expect(@trader.reload.balance).to eq(500.0)
    end

    it "doesn't allow the trader to buy because quantity is invalid" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: -2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to include("Invalid quantity")
      expect(@trader.reload.balance).to eq(500.0)
    end

    it "doesn't allow the trader to buy stocks due to insufficient balance" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 11, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to include("Insufficient balance")
      expect(@trader.reload.balance).to eq(500.0)
    end

    it "restores balance if transaction fails" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'buy' }

      allow_any_instance_of(Transaction).to receive(:save).and_return(false)

      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
    end

  end

  describe "SELL: POST /transactions" do
    it "allows the trader to sell stocks" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      sell_params = { stock_symbol: stock.symbol, quantity: 1, transaction_type: 'sell' }
      post '/transactions', params: sell_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)["transaction"]["action"]).to eq("sell")
      expect(@trader.reload.balance).to eq(450.0)
    end

    it "doesn't allow the trader to sell due to insufficient stock qty" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      sell_params = { stock_symbol: stock.symbol, quantity: 3, transaction_type: 'sell' }
      post '/transactions', params: sell_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to include("Not enough stocks to sell")
      expect(@trader.reload.balance).to eq(400.0)
    end

    it "doesn't allow the trader to sell stocks due to invalid qty input" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      sell_params = { stock_symbol: stock.symbol, quantity: -2, transaction_type: 'sell' }
      post '/transactions', params: sell_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to include("Invalid quantity")
      expect(@trader.reload.balance).to eq(400.0)
    end

    it "doesn't allow the trader to sell because stock is not found" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: "FAKE", quantity: 2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      sell_params = { stock_symbol: "FAKE", quantity: 2, transaction_type: 'sell' }
      post '/transactions', params: sell_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["error"]).to include("Stock not found")
      expect(@trader.reload.balance).to eq(500.0)
    end

    it "restores balance if transaction fails" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      sell_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'sell' }

      allow_any_instance_of(Transaction).to receive(:save).and_return(false)

      post '/transactions', params: sell_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
    end

    it "archives the portfolio if quantity becomes zero" do
      stock = FactoryBot.create(:stock, price_amount: 50.0)
      buy_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'buy' }
      post '/transactions', params: buy_params, headers: { "Authorization" => "Bearer #{@token}" }

      sell_params = { stock_symbol: stock.symbol, quantity: 2, transaction_type: 'sell' }
      post '/transactions', params: sell_params, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)["transaction"]["action"]).to eq("sell")
      expect(@trader.reload.balance).to eq(500)

      archived_portfolio = Portfolio.find_by(stock: stock, trader: @trader, archived: true)
      expect(archived_portfolio).not_to be_nil
    end

  end

end