class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render json: { error: 'not found' }, status: :not_found
  end

  def authenticate_request
    @current_user = User.find(decoded_auth_token[:user_id])
    render json: { error_message: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  private

  def decoded_auth_token
    authorization = request.headers['Authorization']
    return if authorization.blank?

    JsonWebToken.decode(authorization.split(' ').last)
  end
end
