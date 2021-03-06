# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :account, only: %i[show update]

  def index
    render json: Account.joins(:user_accounts).where(user_accounts: { user: current_user })
   end

  def show
    render json: account
  end

  def create
    account = Account.create(account_params)

    if account.valid?
      account.user_accounts.create(user: current_user)
      render json: account, status: :created
    else
      render_validation_errors(account)
    end
  end

  def update
    if account.update(account_params)
      render json: account, status: :accepted
    else
      render_validation_errors(account)
    end
  end

  def destroy
    Account.destroy(params[:id])

    head :no_content
  end

  def validate_field
    validate_unique_field(%w[name], Account)
  end

  private

  def account
    Account.find(params[:id])
  end

  def account_params
    params.permit(:name, :description)
  end
end
