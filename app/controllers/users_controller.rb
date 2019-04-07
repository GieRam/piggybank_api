class UsersController < ApplicationController
  skip_before_action :authenticate_request

  def create
    user = User.new(user_params)
    if user.save
      user.send_activation_email
      render json: user
    else
      render_validation_errors(user)
    end
  end

  def validate_field
    validate_unique_field(%w[email username], User)
  end

  private

  def user_params
    params.permit(
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
end
