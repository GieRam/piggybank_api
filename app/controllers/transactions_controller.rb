class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show update]

  def index
    @transactions = Transaction.all

    render json: @transactions
  end

  def show
    render json: @transaction
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      @transaction.tag_ids = params[:tag_ids]
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(
      :amount,
      :active_from,
      :source,
      :description,
      :account_id
    )
  end
end
