class AddFieldsUser < ActiveRecord::Migration
  def change
  	add_column :users, :name, :string
    add_column :users, :server_id, :integer
  end
end
