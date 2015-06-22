class Song < ActiveRecord::Base
	has_many :user_scores
	max_paginates_per 10
  	paginates_per 10
end
