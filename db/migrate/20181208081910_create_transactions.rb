class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.integer :type
      t.boolean :periodic
      t.datetime :active_from
      t.belongs_to :account, index: true

      t.timestamps
    end
  end
end
