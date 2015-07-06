class AddTypeToStairwaySong < ActiveRecord::Migration
  def change
  	add_column :stairway_songs, :type_song, :integer
  end
end
