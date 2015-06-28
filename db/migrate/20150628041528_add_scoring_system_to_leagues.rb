class AddScoringSystemToLeagues < ActiveRecord::Migration
  def change
  	add_column :leagues, :scoring_mode, :integer
  end
end
