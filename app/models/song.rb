class Song < ActiveRecord::Base
	has_many :user_scores
	max_paginates_per 10
  	paginates_per 10
  	has_many :comments,class_name:"Comment",foreign_key: "song", :dependent => :delete_all
  	validates :server_id, numericality: true
  	validates :server_difficulty_number, numericality: true
  	validates :server_migs_dp_max, numericality: true
end
