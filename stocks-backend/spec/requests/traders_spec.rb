require 'rails_helper'
require 'jwt_auth'

RSpec.describe "Traders", type: :request do
  before(:each) do
    @trader = FactoryBot.create(:trader, balance: 500) 
    @token = JwtAuth.encode({ trader_id: @trader.id })
  end

  describe "PATCH /traders/:id" do
    it "deposits funds into the trader's account" do
      deposit_amount = 50.0
      patch "/traders/#{ @trader.id }", params: { action_type: 'deposit', amount: deposit_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Deposit successful")
      expect(@trader.reload.balance).to eq(550.0) 
    end

    it "returns an error for an invalid deposit amount" do
      deposit_amount = -10.0
      patch "/traders/#{ @trader.id }", params: { action_type: 'deposit', amount: deposit_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid deposit amount")
    end

    it "withdraws funds from the trader's account" do
      withdrawal_amount = 30.0
      patch "/traders/#{ @trader.id }", params: { action_type: 'withdraw', amount: withdrawal_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["message"]).to eq("Withdrawal successful")
      expect(@trader.reload.balance).to eq(470.0)
    end

    it "returns an error for insufficient balance" do
      withdrawal_amount = 600.0
      patch "/traders/#{ @trader.id }", params: { action_type: 'withdraw', amount: withdrawal_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to eq("Insufficient balance")
    end

    it "returns an error for an invalid withdrawal amount" do
      withdrawal_amount = -10.0
      patch "/traders/#{ @trader.id }", params: { action_type: 'withdraw', amount: withdrawal_amount }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid withdrawal amount")
    end

    it "returns an error for an invalid action" do
      invalid_action = 'invalid_action'
      patch "/traders/#{ @trader.id }", params: { action_type: invalid_action, amount: 10.0 }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      expect(JSON.parse(response.body)["error"]).to eq("Invalid action")
    end
  end
end
