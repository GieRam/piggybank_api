class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name, null: false, limit: 255

      t.timestamps
    end
    add_index :accounts, :name, unique: true
  end
end
