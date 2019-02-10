class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Piggybank account activation'
  end

  def password_reset(user)
    @user = user

    mail to: user.email, subject: 'Piggybank password reset'
  end
end
