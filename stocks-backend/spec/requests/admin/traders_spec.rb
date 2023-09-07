require 'rails_helper'
require 'jwt_auth'

RSpec.describe "Admin::Traders", type: :request do
  before(:each) do
    @admin = FactoryBot.create(:admin)
    @token = JwtAuth.encode({ admin_id: @admin.id })
  end

  describe "GET #index /admin/traders" do
    it "returns all traders" do
      FactoryBot.create_list(:trader, 3)
      get '/admin/traders', headers: { "Authorization" => "Bearer #{@token}" }
      
      expect(response).to have_http_status(200)
      traders = JSON.parse(response.body)
      expect(traders.length).to eq(3)
    end

    it "returns all pending traders" do
      FactoryBot.create(:trader, email: "trader1@mail.com", status: "pending")
      FactoryBot.create(:trader, email: "trader2@mail.com", status: "pending")
      get '/admin/traders?status=pending', headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      traders = JSON.parse(response.body)
      expect(traders.length).to eq(2)
    end

    it "returns all pending traders" do
      FactoryBot.create(:trader, email: "trader1@mail.com", status: "pending")
      FactoryBot.create(:trader, email: "trader2@mail.com", status: "approved")
      FactoryBot.create(:trader, email: "trader3@mail.com", status: "approved")
      get '/admin/traders?status=approved', headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      traders = JSON.parse(response.body)
      expect(traders.length).to eq(2)
    end

    it "returns an error because user is not an admin" do
      trader = FactoryBot.create(:trader, email: "user@mail.com")
      token = JwtAuth.encode({ trader_id: trader.id })

      FactoryBot.create(:trader, email: "trader1@mail.com")
      FactoryBot.create(:trader, email: "trader2@mail.com")
      
      get '/admin/traders', headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(403)
      response_body = JSON.parse(response.body)
      expect(response_body["error"]).to include("Only admin users are allowed to perform this action")
    end
  end

  describe "GET #show /admin/traders/:id" do
    it "returns a specific trader" do
      trader = FactoryBot.create(:trader)
      
      get "/admin/traders/#{trader.id}", headers: { "Authorization" => "Bearer #{@token}" }
      
      expect(response).to have_http_status(200)
      trader_response = JSON.parse(response.body)
      expect(trader_response["email"]).to eq(trader.email)
    end
  end

  describe "POST #create /admin/traders" do
    it "creates a new trader account" do
      trader_params = FactoryBot.attributes_for(:trader)

      post "/admin/traders", params: { trader: trader_params }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(201)
      new_trader = JSON.parse(response.body)
      expect(new_trader["email"]).to eq(trader_params[:email])
    end

    it "doesn't create a new trader account due to incomplete params" do
      trader_params = FactoryBot.attributes_for(:trader, :without_name)

      post "/admin/traders", params: { trader: trader_params }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      trader = JSON.parse(response.body)
      expect(trader["errors"]).to include("First name can't be blank")
    end
  end

  describe "PATCH /admin/traders/:id" do
    it "updates a trader from pending to approved" do
      pending_trader = FactoryBot.create(:trader, status: "pending", email: "pending@mail.com")
      trader_params = FactoryBot.attributes_for(:trader, status: "approved")

      patch "/admin/traders/#{pending_trader.id}", params: { trader: trader_params }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      updated_trader = JSON.parse(response.body)
      expect(updated_trader["status"]).to eq("approved")
    end

    it "updates a trader from approved to pending" do
      approved_trader = FactoryBot.create(:trader, status: "approved", email: "approved@mail.com")
      trader_params = FactoryBot.attributes_for(:trader, status: "pending")

      patch "/admin/traders/#{approved_trader.id}", params: { trader: trader_params }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(200)
      updated_trader = JSON.parse(response.body)
      expect(updated_trader["status"]).to eq("pending")
    end

    it "does not update a trader's email because it's already taken" do
      trader1 = FactoryBot.create(:trader, email: "user1@mail.com")
      trader2 = FactoryBot.create(:trader, email: "user2@mail.com")
      trader_params = FactoryBot.attributes_for(:trader, email: "user1@mail.com")

      patch "/admin/traders/#{trader2.id}", params: { trader: trader_params }, headers: { "Authorization" => "Bearer #{@token}" }

      expect(response).to have_http_status(422)
      invalid_email = JSON.parse(response.body)
      expect(invalid_email["errors"]).to include ("Email has already been taken")
    end
  end
end
