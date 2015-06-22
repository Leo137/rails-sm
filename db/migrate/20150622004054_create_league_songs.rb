class CreateLeagueSongs < ActiveRecord::Migration
  def change
    create_table :league_songs do |t|
      t.decimal :factor
      t.references :song, index: true, foreign_key: true
      t.references :league, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
