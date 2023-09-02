require 'rails_helper'
require 'jwt_auth'

RSpec.describe "Portfolios", type: :request do
  before(:each) do
    @trader = FactoryBot.create(:trader)
    @token = JwtAuth.encode({ trader_id: @trader.id })
  end

  describe "GET /portfolios" do
    it "returns the trader's portfolio" do
      FactoryBot.create(:portfolio, trader: @trader)
      get '/portfolios', headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      portfolio = JSON.parse(response.body).first
      expect(portfolio["trader_id"]).to eq(@trader.id)
    end

    it "returns an error due to invalid token" do
      FactoryBot.create(:portfolio, trader: @trader)
      get '/portfolios', headers: { "Authorization" => "invalid_token" }

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)["error"]).to include("Invalid token or user not found")
    end

    it "returns an error due to missing token" do
      FactoryBot.create(:portfolio, trader: @trader)
      get '/portfolios'

      expect(response).to have_http_status(401)
      expect(JSON.parse(response.body)["error"]).to include("Authorization token missing")
    end
  end
end