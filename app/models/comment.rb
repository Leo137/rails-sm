class Comment < ActiveRecord::Base
	max_paginates_per 10
  	paginates_per 10
	belongs_to :author, class_name: "User",foreign_key: "author"
  	belongs_to :user, class_name: "User",foreign_key: "user"
  	belongs_to :song, class_name: "Song",foreign_key: "song"
  	belongs_to :league, class_name: "League",foreign_key: "league"
  	belongs_to :news, class_name: "News",foreign_key: "news"
  	belongs_to :stairway, class_name: "Stairway",foreign_key: "stairway"
end