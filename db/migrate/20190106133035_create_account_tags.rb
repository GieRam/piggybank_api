class CreateAccountTags < ActiveRecord::Migration[5.2]
  def change
    create_table :account_tags do |t|
      t.belongs_to :account, index: true
      t.belongs_to :tag, index: true
      t.timestamps
    end
  end
end
