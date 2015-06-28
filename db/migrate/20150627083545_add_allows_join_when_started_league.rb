class AddAllowsJoinWhenStartedLeague < ActiveRecord::Migration
  def change
  	add_column :leagues, :allows_join_when_started, :boolean
  end
end
