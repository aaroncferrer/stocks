class ApplicationController < ActionController::API
  before_action :check_auth

  def check_auth
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        decoded_token = JwtAuth.decode(token)
        admin_id = decoded_token['admin_id']
        trader_id = decoded_token['trader_id']

        if admin_id
          @current_user = Admin.find(admin_id)
        elsif trader_id
          @current_user = Trader.find(trader_id)
        end
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: 'Invalid token or user not found' }, status: :unauthorized
      end
    else
      render json: { error: 'Authorization token missing' }, status: :unauthorized
    end
  end
end