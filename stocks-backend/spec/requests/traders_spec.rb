require 'rails_helper'
require 'jwt_auth'

RSpec.describe "Traders", type: :request do
  before(:each) do
    @trader = FactoryBot.create(:trader, balance: 500) 
    @token = JwtAuth.encode({ trader_id: @trader.id })
  end

  describe "POST /traders/deposit" do
    it "deposits funds into the trader's account" do
      deposit_amount = 50.0
      post '/traders/deposit', params: { amount: deposit_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Deposit successful")
      expect(@trader.reload.balance).to eq(550.0) 
    end

    it "returns an error for an invalid deposit amount" do
      deposit_amount = -10.0
      post '/traders/deposit', params: { amount: deposit_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid deposit amount")
    end
  end

  describe "POST /traders/withdraw" do
    it "withdraws funds from the trader's account" do
      withdrawal_amount = 30.0
      post '/traders/withdraw', params: { amount: withdrawal_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Withdrawal successful")
      expect(@trader.reload.balance).to eq(470.0) #
    end

    it "returns an error for insufficient balance" do
      withdrawal_amount = 600.0
      post '/traders/withdraw', params: { amount: withdrawal_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid withdrawal amount or insufficient balance")
    end
  end
end
