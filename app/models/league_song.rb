class LeagueSong < ActiveRecord::Base
  belongs_to :song
  belongs_to :league
end
