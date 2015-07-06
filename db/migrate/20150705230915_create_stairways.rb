class CreateStairways < ActiveRecord::Migration
  def change
    create_table :stairways do |t|
      t.string :name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
