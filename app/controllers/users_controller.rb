class UsersController < ApplicationController
  skip_before_action :authenticate_request

  VALIDATABLE_FIELDS = %w[email username].freeze

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
    render json: { error_message: 'Unsupported field' }, status: :bad_request if
      (params.keys & VALIDATABLE_FIELDS).empty?

    VALIDATABLE_FIELDS.each do |field|
      if invalid_user_field(field)
        return render json: { error_message: "#{field.to_s.capitalize} is taken" },
                      status: :bad_request
      end
    end
  end

  private

  def invalid_user_field(field)
    params[field] && User.exists?(["#{field} = ?", params[field]])
  end

  def user_params
    params.permit(
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
end
