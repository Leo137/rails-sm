json.array!(@leagues) do |league|
  json.extract! league, :id, :name, :description, :organizer_id
  json.url league_url(league, format: :json)
end
