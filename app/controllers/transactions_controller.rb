# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    render json: [{ description: 'hello' }, { description: 'world' }]
  end
end
