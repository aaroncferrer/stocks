require 'rails_helper'

RSpec.describe "AdminAuthControllers", type: :request do
  # POST Admin Signup
  describe "POST /admin/signup" do
    it "creates a new admin" do
      admin_params = FactoryBot.attributes_for(:admin)

      post "/admin/signup", params: { admin: admin_params }

      expect(response).to have_http_status(201)
      admin = JSON.parse(response.body)
      expect(admin["email"]).to eq(admin_params[:email])
    end

    it "doesn't create an admin if email is already taken" do
      existing_admin = FactoryBot.create(:admin, email: "taken@mail.com")
      admin_params = FactoryBot.attributes_for(:admin, email: "taken@mail.com")

      post "/admin/signup", params: { admin: admin_params }

      expect(response).to have_http_status(422)
      admin = JSON.parse(response.body)
      expect(admin["errors"]).to include("Email has already been taken")
    end

    it "doesn't create an admin if passwords don't match" do
      admin_params = FactoryBot.attributes_for(:admin, password: "password", password_confirmation: "wrong_password")

      post "/admin/signup", params: { admin: admin_params }

      expect(response).to have_http_status(422)
      admin = JSON.parse(response.body)
      expect(admin["errors"]).to include("Password confirmation doesn't match Password")
    end
  end

  # POST Admin Login
  describe "POST /admin/login" do
    before(:each) do
      @admin = FactoryBot.create(:admin, email: "test@example.com", password: "password")
    end

    it "returns a JWT on successful login" do
      login_params = {
        email: "test@example.com",
        password: "password"
      }

      post "/admin/login", params: login_params

      expect(response).to have_http_status(200)
      expect(response.body).to include("token")
    end

    it "returns an error on failed login" do
      login_params = {
        email: "test@example.com",
        password: "wrong_password"
      }

      post "/admin/login", params: login_params

      expect(response).to have_http_status(401)
      expect(response.body).to include("Invalid email or password")
    end
  end
end
