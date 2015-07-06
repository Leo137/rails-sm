class Stairway < ActiveRecord::Base
  belongs_to :user
  has_many :stairway_songs, :dependent => :delete_all
  has_many :songs, through: :stairway_songs
  has_many :comments,class_name:"Comment",foreign_key: "stairway", :dependent => :delete_all
end