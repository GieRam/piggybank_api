class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      render json: user
    else
      render json: { error_message: 'Invalid activation' }, status: :unauthorized
    end
  end
end
