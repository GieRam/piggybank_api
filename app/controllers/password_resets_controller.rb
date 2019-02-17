
class PasswordResetsController < ApplicationController
  def create
    @user = User.find_by(email: params[:email].downcase)
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
  end
end
