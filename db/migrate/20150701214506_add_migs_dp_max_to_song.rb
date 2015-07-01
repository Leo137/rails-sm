class AddMigsDpMaxToSong < ActiveRecord::Migration
  def change
  	add_column :songs, :server_migs_dp_max, :integer
  end
end
