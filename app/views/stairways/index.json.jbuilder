json.array!(@stairways) do |stairway|
  json.extract! stairway, :id, :name, :user_id
  json.url stairway_url(stairway, format: :json)
end
