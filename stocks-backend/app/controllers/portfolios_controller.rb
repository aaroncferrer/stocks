require 'jwt_auth'

class PortfoliosController < ApplicationController
  def index
    portfolio = @current_user.portfolios.includes(:stock)
    render json: portfolio, include: :stock
  end

  def show
    portfolio = Portfolio.find_by(id: params[:id], trader_id: @current_user.id)
    if portfolio.nil?
      render json: { error: 'Portfolio not found' }, status: :not_found
    else
      render json: portfolio, include: :stock
    end
  end
end

