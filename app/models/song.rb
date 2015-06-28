class Song < ActiveRecord::Base
	has_many :user_scores
	max_paginates_per 10
  	paginates_per 10
  	has_many :comments,class_name:"Comment",foreign_key: "song", :dependent => :delete_all
end
