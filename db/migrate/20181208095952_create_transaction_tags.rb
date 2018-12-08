class CreateTransactionTags < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_tags do |t|
      t.belongs_to :transaction, index: true
      t.belongs_to :tag, index: true
      t.timestamps
    end
  end
end
