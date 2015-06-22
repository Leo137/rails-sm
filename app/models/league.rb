class League < ActiveRecord::Base
  belongs_to :organizer,class_name:"User"
  has_many :contestants
  has_many :users, through: :contestants
  has_many :league_songs
  has_many :songs, through: :league_songs
end
