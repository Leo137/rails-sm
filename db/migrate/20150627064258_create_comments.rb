class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author
      t.text :comment
      t.integer :user
      t.integer :song
      t.integer :league

      t.timestamps null: false
    end
    
    add_index :comments, :user
    add_index :comments, :song
    add_index :comments, :league
  end
end
