require 'rails_helper'

RSpec.describe "Portfolios", type: :request do
  before(:each) do
    @trader = FactoryBot.create(:trader)
    @token = JwtAuth.encode({ trader_id: @trader.id })
  end

  describe "GET /portfolios" do
    it "returns the trader's portfolios" do
      FactoryBot.create_list(:portfolio, 3, trader: @trader)
      get '/portfolios', headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      portfolios = JSON.parse(response.body)
      expect(portfolios.length).to eq(3)
    end
  end

  describe "GET /portfolios/:id" do
    it "returns a specific portfolio for the trader" do
      portfolio = FactoryBot.create(:portfolio, trader: @trader)
      get "/portfolios/#{portfolio.id}", headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["id"]).to eq(portfolio.id)
    end

    it "returns an error for a non-existent portfolio" do
      get "/portfolios/999", headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(404)
      expect(JSON.parse(response.body)["error"]).to eq("Portfolio not found")
    end
  end
end

