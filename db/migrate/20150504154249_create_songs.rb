class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.text :name
      t.string :server_difficulty_name
      t.string :server_difficulty_number
      t.integer :server_id

      t.timestamps null: false
    end
  end
end
