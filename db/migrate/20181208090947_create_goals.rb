class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.string :name, null: false, limit: 255
      t.decimal :amount, null: false, precision: 15, scale: 2
      t.integer :priority, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
