class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount, null: false
      t.integer :source, null: false
      t.datetime :active_from, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :description, limit: 255
      t.belongs_to :account, index: true

      t.timestamps
    end
  end
end
