class CreateRelationshipSongs < ActiveRecord::Migration
  def change
    create_table :relationship_songs do |t|
      t.references :relationship, index: true, foreign_key: true
      t.references :song, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
