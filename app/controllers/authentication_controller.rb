# TODO: better error handling.
# https://www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api
class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      JsonWebToken.encode(user_id: user.id)
    else
      render json: { error_message: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
