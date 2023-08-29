require 'jwt_auth'

class TradersController < ApplicationController
  def deposit
    amount = params[:amount].to_f
    if amount.positive?
      @current_user.update_columns(balance: @current_user.balance + amount)
      render json: { message: 'Deposit successful', balance: @current_user.balance }
    else
      render json: { error: 'Invalid deposit amount' }, status: :unprocessable_entity
    end
  end

  def withdraw
    amount = params[:amount].to_f
    if amount.positive? && @current_user.balance >= amount
      @current_user.update_columns(balance: @current_user.balance - amount)
      render json: { message: 'Withdrawal successful', balance: @current_user.balance }
    else
      render json: { error: 'Invalid withdrawal amount or insufficient balance' }, status: :unprocessable_entity
    end
  end
end
