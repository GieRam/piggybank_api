# frozen_string_literal: true

class ApplicationController < ActionController::API
  include AuthHelper

  before_action :authenticate_request

  attr_reader :current_user

  rescue_from Exception, with: :internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def internal_server_error
    render json: { error_message: 'Internal error' }, status: :internal_server_error
  end

  def not_found
    render json: { error_message: 'Not found' }, status: :not_found
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
end
