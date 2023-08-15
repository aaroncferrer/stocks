require 'jwt_auth'

class AdminAuthController < ApplicationController
  skip_before_action :check_auth

  def signup
    admin = Admin.new(admin_params)
    if admin.save
      render json: admin, status: :created
    else
      render json: { errors: admin.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      token = JwtAuth.encode({ admin_id: admin.id })
      render json: { token: token, admin: admin.as_json(only: [:id, :first_name, :last_name, :email]) }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
