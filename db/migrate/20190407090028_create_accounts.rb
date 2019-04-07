class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name, limit: 50, null: false
      t.text :description
      t.index :name, unique: true
    end
  end
end
