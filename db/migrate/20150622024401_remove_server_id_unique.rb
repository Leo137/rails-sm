class RemoveServerIdUnique < ActiveRecord::Migration
  def change
  	remove_index :songs, :server_id
  end
end
