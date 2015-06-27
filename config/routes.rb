Rails.application.routes.draw do
  
  get 'songs/update_score' => 'songs#update_score_get'
  get 'songs/publish_comment' => 'songs#publish_comment_show'
  get 'songs/publish_comment/:page' => 'songs#publish_comment_show'
  post 'songs/publish_comment' => 'songs#publish_comment_post'
  delete 'songs/publish_comment' => 'songs#publish_comment_delete'
  resources :songs
  devise_for :users, :controllers => { registrations: 'registrations' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  root 'songs#index'

  get 'users' => 'users#index'
  get 'users/order/name' => 'users#index'
  get 'users/order/rank' => 'users#index_rank'
  get 'users/page/:page' => 'users#index'
  get 'users/order/name/page/:page' => 'users#index'
  get 'users/order/rank/page/:page' => 'users#index_rank'
  get 'users/friend_request' => 'users#friend_request_show'
  post 'users/friend_request' => 'users#friend_request_post'
  delete 'users/friend_request' => 'users#friend_request_delete'
  put 'users/friend_request' => 'users#friend_request_put'
  get 'users/propose_song' => 'users#propose_song_show'
  get 'users/propose_song/:page' => 'users#propose_song_show'
  post 'users/propose_song' => 'users#propose_song_post'
  delete 'users/propose_song' => 'users#propose_song_delete'
  get 'users/publish_comment' => 'users#publish_comment_show'
  get 'users/publish_comment/:page' => 'users#publish_comment_show'
  post 'users/publish_comment' => 'users#publish_comment_post'
  delete 'users/publish_comment' => 'users#publish_comment_delete'
  get 'users/:id' => 'users#show'

  post 'leagues/join_league' => 'leagues#join_league_post'
  delete 'leagues/join_league' => 'leagues#join_league_delete'
  get 'leagues/add_song' => 'leagues#add_song_show'
  get 'leagues/add_song/:page' => 'leagues#add_song_show'
  post 'leagues/add_song' => 'leagues#add_song_post'
  put 'leagues/add_song' => 'leagues#add_song_put'
  delete 'leagues/add_song' => 'leagues#add_song_delete'
  get 'leagues/publish_comment' => 'leagues#publish_comment_show'
  get 'leagues/publish_comment/:page' => 'leagues#publish_comment_show'
  post 'leagues/publish_comment' => 'leagues#publish_comment_post'
  delete 'leagues/publish_comment' => 'leagues#publish_comment_delete'
  resources :leagues
  
  
end
