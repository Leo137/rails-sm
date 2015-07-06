class StairwaySong < ActiveRecord::Base
  belongs_to :stairway
  belongs_to :song
  max_paginates_per 10
  paginates_per 10
end
