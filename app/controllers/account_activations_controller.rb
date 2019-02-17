# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  skip_before_action :authenticate_request

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:token])
      user.activate
      render json: { token: user.auth_token }
    else
      render json: { error_message: 'Invalid activation' }, status: :unauthorized
    end
  end
end
