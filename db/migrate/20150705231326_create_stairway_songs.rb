class CreateStairwaySongs < ActiveRecord::Migration
  def change
    create_table :stairway_songs do |t|
      t.references :stairway, index: true, foreign_key: true
      t.references :song, index: true, foreign_key: true
      t.float :rate
      t.float :points

      t.timestamps null: false
    end
  end
end
