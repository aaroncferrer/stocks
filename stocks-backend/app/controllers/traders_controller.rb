require 'jwt_auth'

class TradersController < ApplicationController
  def update
    amount = params[:amount].to_f
    action = params[:action_type]

    case action
    when 'deposit'
      if amount.positive? && @current_user.deposit(amount)
        render json: { message: 'Deposit successful', balance: @current_user.balance }
      else 
        render json: { error: 'Invalid deposit amount' }, status: :unprocessable_entity
      end
    when 'withdraw'
      if amount.positive? && @current_user.withdraw(amount)
        render json: { message: 'Withdrawal successful', balance: @current_user.balance }
      elsif amount > @current_user.balance
        render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
      else
        render json: { error: 'Invalid withdrawal amount' }, status: :unprocessable_entity
      end
    else 
      render json: { error: 'Invalid action' }, status: :unprocessable_entity
    end
  end
end
