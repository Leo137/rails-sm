class CreateContestants < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
      t.integer :status
      t.references :user, index: true, foreign_key: true
      t.references :league, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
