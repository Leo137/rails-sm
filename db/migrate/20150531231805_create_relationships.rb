class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_one_id
      t.integer :user_two_id
      t.integer :status

      t.timestamps null: false
    end

    add_index :relationships, :user_one_id
    add_index :relationships, :user_two_id
    add_index :relationships, [:user_one_id, :user_two_id], unique: true
  end
end
