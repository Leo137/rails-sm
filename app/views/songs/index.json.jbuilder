json.array!(@songs) do |song|
  json.extract! song, :id, :name, :server_difficulty_name, :server_difficulty_number, :server_id
  json.url song_url(song, format: :json)
end
