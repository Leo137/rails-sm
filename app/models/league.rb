class League < ActiveRecord::Base
	validates_datetime :finish_date, :after => :start_date
	belongs_to :organizer,class_name:"User"
	has_many :contestants, :dependent => :delete_all
	has_many :users, through: :contestants
	has_many :league_songs, :dependent => :delete_all
	has_many :songs, through: :league_songs
	has_many :comments,class_name:"Comment",foreign_key: "league", :dependent => :delete_all
end
