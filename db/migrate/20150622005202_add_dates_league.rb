class AddDatesLeague < ActiveRecord::Migration
  def change
  	add_column :leagues, :start_date, :date
  	add_column :leagues, :finish_date, :date
  end
end
