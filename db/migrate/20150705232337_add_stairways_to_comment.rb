class AddStairwaysToComment < ActiveRecord::Migration
  def change
  	add_column :comments, :stairway, :integer
  	add_index :comments, :stairway
  end
end
