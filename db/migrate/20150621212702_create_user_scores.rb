class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.integer :server_marvelous
      t.integer :server_perfects
      t.integer :server_greats
      t.integer :server_goods
      t.integer :server_bads
      t.integer :server_misses
      t.integer :server_ok
      t.integer :server_ng
      t.decimal :server_percent
      t.integer :server_grade
      t.integer :server_migs_dp_obtained
      t.integer :server_migs_dp_max
      t.date :server_date
      t.references :user, index: true, foreign_key: true
      t.references :song, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
