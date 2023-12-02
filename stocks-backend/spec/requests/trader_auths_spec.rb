require 'rails_helper'

RSpec.describe "TraderAuths", type: :request do
  # POST Trader Signup
  describe "POST /trader/signup" do
    it "creates a new trader and sends a notification email" do
      trader_params = FactoryBot.attributes_for(:trader)

      expect {
        post '/trader/signup', params: { trader: trader_params }
    }.to change { ActionMailer::Base.deliveries.count }.by(2)

      expect(response).to have_http_status(201)
      trader = JSON.parse(response.body)
      expect(trader["email"]).to eq(trader_params[:email])

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include("arcferrer5@gmail.com")
      expect(email.subject).to eq("Welcome to Our App - Signup Confirmation")
    end

    it "doesn't create a trader if email is already taken" do
      existing_trader = FactoryBot.create(:trader, email: "taken@mail.com")
      trader_params = FactoryBot.attributes_for(:trader, email: "taken@mail.com")

      post "/trader/signup", params: { trader: trader_params }

      expect(response).to have_http_status(422)
      trader = JSON.parse(response.body)
      expect(trader["errors"]).to include("Email has already been taken")
    end
  end

  describe "POST /trader/login" do
    before(:each) do
      @trader = FactoryBot.create(:trader, email: "test@example.com", password: "password", status: "approved")
    end

    it "returns an error if trader account is pending" do
      pending_trader = FactoryBot.create(:trader, email: "pending@example.com", password: "password", status: "pending")
      login_params = {
        email: "pending@example.com",
        password: "password"
      }

      post '/trader/login', params: login_params

      expect(response).to have_http_status(401)
      expect(response.body).to include("Trader account not yet approved")
    end

    it "returns a JWT on successful login" do
      login_params = {
        email: "test@example.com",
        password: "password"
      }

      post "/trader/login", params: login_params

      expect(response).to have_http_status(200)
      expect(response.body).to include("token")
    end

    it "returns an error on failed login" do
      login_params = {
        email: "test@example.com",
        password: "wrong_password"
      }

      post "/trader/login", params: login_params

      expect(response).to have_http_status(401)
      expect(response.body).to include("Invalid email or password")
    end
  end
end
