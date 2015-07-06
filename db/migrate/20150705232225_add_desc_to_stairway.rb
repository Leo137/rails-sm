class AddDescToStairway < ActiveRecord::Migration
  def change
  	add_column :stairways, :description, :string
  end
end
