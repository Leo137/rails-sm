class AddVisibleToLeague < ActiveRecord::Migration
  def change
  	add_column :leagues, :visible, :boolean
  end
end
