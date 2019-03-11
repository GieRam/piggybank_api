# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create]

  def create
    return render_unauthorized 'Invalid client' if params[:client_id] != 'piggybank-app'

    if params[:grant_type] == 'password'
      user = User.find_by(email: params[:email].downcase)

      if user&.authenticate(params[:password])
        render json: login(user)
      else
        render_unauthorized 'Invalid credentials'
      end
    elsif params[:grant_type] == 'refresh_token'
      user = User.find_by(refresh_token: params[:refresh_token])

      if user.present?
        render json: login(user)
      else
        render_unauthorized 'Invalid refresh token'
      end
    else
      render_unauthorized 'Invalid or missing grant type'
    end
  end

  def destroy
    @current_user.update_column(:refresh_token, nil)
  end
end
