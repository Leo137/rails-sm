class RelationshipSong < ActiveRecord::Base
  belongs_to :relationship
  belongs_to :song
end
