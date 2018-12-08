class CreateGoalTags < ActiveRecord::Migration[5.2]
  def change
    create_table :goal_tags do |t|
      t.belongs_to :goal, index: true
      t.belongs_to :tag, index: true
      t.timestamps
    end
  end
end
