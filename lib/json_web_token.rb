# frozen_string_literal: true

class JsonWebToken
  def self.encode(payload, exp = 2.hours.from_now)
    payload[:iat] = Time.zone.now.to_i
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
    HashWithIndifferentAccess.new body
  rescue StandardError
    nil
  end
end