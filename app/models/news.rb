class News < ActiveRecord::Base
  max_paginates_per 3
  paginates_per 3
  belongs_to :user
  has_many :comments,class_name:"Comment",foreign_key: "news", :dependent => :delete_all
end
