class AddIdUserScore < ActiveRecord::Migration
  def change
  	add_column :user_scores, :server_id, :integer
  end
end
