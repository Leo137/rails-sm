json.array!(@news) do |news|
  json.extract! news, :id, :content, :user_id
  json.url news_url(news, format: :json)
end
