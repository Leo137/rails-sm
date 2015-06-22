class AddFieldsUserScore < ActiveRecord::Migration
  def change
  	add_column :user_scores, :server_toasty_count, :integer
  	add_column :user_scores, :server_max_combo, :integer
  	add_column :user_scores, :server_mines_hit, :integer
  	add_column :user_scores, :server_mines_missed, :integer
  	add_column :user_scores, :server_score, :integer
  	add_column :user_scores, :server_timing, :integer
  	add_column :user_scores, :server_mods, :string
  end
end
