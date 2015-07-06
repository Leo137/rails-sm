class ServerValidator < ActiveModel::Validator
  def validate(user)
    if user.server_id == nil || user.server_id == "" || user.server_id.to_i.to_s != user.server_id.to_s
      user.errors[:base] << "You must profile a valid server id"
    else
      url = ApplicationHelper.get_profile_server_url(user.server_id)
      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
      end
      doc = Nokogiri::HTML(open(url),nil,charset)
      user_name = doc.xpath('/html/body/div/div[2]/div[2]/div[1]/center')
      if user_name.children[0] == nil || user_name.children[0].text != user.name
        user.errors[:base] << "Name is different from server name: " +  user_name.children[0].text
      end
    end
  end
end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates_with ServerValidator
  validates :server_id, uniqueness: true
  validates :name, uniqueness: true
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

  has_many :user_scores, :dependent => :delete_all
  has_many :comments,class_name:"Comment",foreign_key: "user", :dependent => :delete_all
  has_many :created_songs,class_name:"Song",foreign_key: "creator", :dependent => :delete_all
end
