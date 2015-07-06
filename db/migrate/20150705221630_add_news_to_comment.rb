class AddNewsToComment < ActiveRecord::Migration
  def change
  	add_column :comments, :news, :integer
  	add_index :comments, :news
  end
end
