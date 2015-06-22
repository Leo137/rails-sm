class ChangeToDateTime < ActiveRecord::Migration
  def up
   change_column :leagues, :start_date, :datetime
   change_column :leagues, :finish_date, :datetime
   change_column :user_scores, :server_date, :datetime
  end

  def down
   change_column :leagues, :start_date, :date
   change_column :leagues, :finish_date, :date
   change_column :user_scores, :server_date, :date
  end
end
