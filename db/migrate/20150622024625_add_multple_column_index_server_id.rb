class AddMultpleColumnIndexServerId < ActiveRecord::Migration
  def change
  	add_index :songs, [:server_difficulty_name, :server_difficulty_number, :server_id], :unique => true, :name => 'difficulty_index'
  end
end
