# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  skip_before_action :authenticate_request
  before_action :user, only: %i[create update]
  before_action :check_expiration, only: %i[update]
  before_action :valid_user, only: %i[update]

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      render json: @user
    else
      render json: { error_message: "User by email: #{params[:email]} not found" },
             status: :bad_request
    end
  end

  def update
    if @user.update(user_params)
      @user.update_attribute(:reset_digest, nil)
      render json: login(@user)
    else
      render_validation_errors(@user)
    end
  end

  private

  def user
    @user = User.find_by(email: params[:email].downcase)
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end

  def valid_user
    render_unauthorized 'Invalid user' unless @user&.activated? &&
                                              @user&.authenticated?(:reset, params[:id])
  end

  def check_expiration
    render_unauthorized 'Reset token expired' if @user.password_reset_expired?
  end
end
