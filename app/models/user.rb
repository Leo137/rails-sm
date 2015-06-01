class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  max_paginates_per 10
  paginates_per 10
  has_many :friends_one, -> { where status: 1 },
  									class_name:  "Relationship",
                                  	foreign_key: "user_one_id"
  has_many :friends_two, -> { where status: 1 },
  									class_name:  "Relationship",
                                  	foreign_key: "user_two_id"                          

  def friends
   	friends_one.union(friends_two)
  end

  has_many :friends_one_req, -> { where status: 0 },
  									class_name:  "Relationship",
                                  	foreign_key: "user_one_id"
  has_many :friends_two_req, -> { where status: 0 },
  									class_name:  "Relationship",
                                  	foreign_key: "user_two_id"                        

  def friends_request
   	friends_one_req.union(friends_two_req)
  end

  has_many :friends_one_all, 
  									class_name:  "Relationship",
                                  	foreign_key: "user_one_id"
  has_many :friends_two_all, 
  									class_name:  "Relationship",
                                  	foreign_key: "user_two_id"                        

  def friends_all
   	friends_one_all.union(friends_two_all)
  end
end
