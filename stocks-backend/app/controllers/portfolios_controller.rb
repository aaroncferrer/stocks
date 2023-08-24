require 'jwt_auth'

class PortfoliosController < ApplicationController
  def index
    portfolio = @current_user.portfolios.includes(:stock)
    render json: portfolio, include: :stock
  end
end

