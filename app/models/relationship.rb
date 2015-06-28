class Relationship < ActiveRecord::Base
	belongs_to :user_one, class_name: "User"
  	belongs_to :user_two, class_name: "User"
  	has_many :relationship_songs, :dependent => :delete_all
  	has_many :songs, through: :relationship_songs
end
