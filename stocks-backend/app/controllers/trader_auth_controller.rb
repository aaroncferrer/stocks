require 'jwt_auth'

class TraderAuthController < ApplicationController
  skip_before_action :check_auth, only: [:signup, :login]
  
  def signup
    trader = Trader.new(trader_params)
    if trader.save
      TraderMailer.signup_notification(trader).deliver_now
      TraderMailer.admin_signup_notification(trader).deliver_now
      render json: trader, status: :created
    else
      render json: { errors: trader.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    trader = Trader.find_by(email: params[:email])
    if trader&.authenticate(params[:password])
      if trader.approved?
        token = JwtAuth.encode({ trader_id: trader.id })
        render json: { token: token, trader: trader.as_json(only: [:id, :first_name, :last_name, :email, :balance]) }, status: :ok
      else
        render json: { error: "Trader account not yet approved" }, status: :unauthorized
      end
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def trader_params
    params.require(:trader).permit(:first_name, :last_name, :email, :password, :password_confirmation, :balance)
  end

end
