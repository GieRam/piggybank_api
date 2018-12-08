class CreateUserAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_accounts do |t|
      t.belongs_to :user, index: true
      t.belongs_to :account, index: true
      t.timestamps
    end
  end
end
