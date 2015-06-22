class MakeServerIdUnique < ActiveRecord::Migration
  def change
  	add_index :songs, :server_id, :unique => true
  	add_index :users, :server_id, :unique => true
  	add_index :user_scores, :server_id, :unique => true
  end
end
