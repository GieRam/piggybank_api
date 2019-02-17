# frozen_string_literal: true

class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user

    mail to: user.email, subject: 'PiggyBank account activation'
  end

  def password_reset(user)
    @user = user

    mail to: user.email, subject: 'PiggyBank password reset'
  end
end
