class AddDetailsToSong < ActiveRecord::Migration
  def change
  	add_column :songs, :pack_name, :string
  	add_column :songs, :description, :string
  	add_column :songs, :download_link, :string
  end
end