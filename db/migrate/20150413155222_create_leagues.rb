class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :description
      t.references :organizer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
