class AddUserReferenceToSong < ActiveRecord::Migration
  def change
  	add_column :songs, :creator, :integer
  end
end
