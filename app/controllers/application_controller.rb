# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def internal_server_error
    render json: { error_message: 'Internal error' }, status: :internal_server_error
  end

  def not_found
    render json: { error_message: 'Not found' }, status: :not_found
  end

  def authenticate_request
    if decoded_auth_token
      @current_user = User.find(decoded_auth_token[:user_id])
    else
      render json: { error_message: 'Missing token' }, status: :unauthorized
      return
    end

    render json: { error_message: 'Invalid token' }, status: :unauthorized unless @current_user
  end

  def render_validation_errors(record)
    hash = { error_message: 'Validation error' }
    hash[:errors] = record.errors.map do |field, message|
      {
        field: field.to_s,
        value: Array(message).join(', '),
      }
    end
    render json: hash, status: :bad_request
  end

  private

  def decoded_auth_token
    authorization = request.headers['Authorization']
    return if authorization.blank?

    @decoded_auth_token ||= JsonWebToken.decode(authorization.split(' ').last)
  end
end
