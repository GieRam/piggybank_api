# frozen_string_literal: true

module AuthHelper
  def login(user)
    {
      access_token: user.auth_token,
      refresh_token: user.set_refresh_token,
    }
  end

  def authenticate_request
    return render json: { error_message: 'Missing token' }, status: :unauthorized unless
      decoded_auth_token

    @current_user = User.find(decoded_auth_token[:user_id])

    render json: { error_message: 'Invalid token' }, status: :unauthorized unless @current_user
  end

  def render_unauthorized(message = 'Unauthorized')
    render json: { error_message: message }, status: :unauthorized
  end

  private

  def decoded_auth_token
    authorization = request.headers['Authorization']
    return if authorization.blank?

    @decoded_auth_token ||= JsonWebToken.decode(authorization.split(' ').last)
  end
end
