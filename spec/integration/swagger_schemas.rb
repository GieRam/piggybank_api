# frozen_string_literal: true

module SwaggerSchemas
  module_function

  def validation_errors
    {
      type: :object, properties: {
        error_message: { type: :string },
        errors: {
          type: :array,
          items: {
            type: :object,
            properties: {
              field: { type: :string },
              value: { type: :string },
            },
          },
        },
      }
    }
  end

  def user
    {
      type: :object,
      properties: {
        username: { type: :string },
        email: { type: :string },
      },
    }
  end

  def login
    {
      type: :object,
      properties: {
        access_token: { type: :string },
        refresh_token: { type: :string },
      },
    }
  end

  def error
    {
      type: :object,
      properties: {
        error_message: { type: :string }
      },
    }
  end
end
