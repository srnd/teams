Rails.application.routes.draw do
  root 'main#index'

  get '/login' => 'users#login'
  post '/login' => 'users#post_login'

  get '/oauth/s5' => 'main#s5'

  get '/logout' => 'users#logout'

  get '/me' => 'users#me'

  get '/teams/code' => 'teams#code'
  get '/teams/join' => 'teams#join'
  post '/teams/join' => 'teams#join_team'
  get '/teams/leave' => 'teams#leave'
  post '/teams/project' => 'teams#save_project'
  get '/teams/batch/:batch_id/event/:id' => 'teams#event', as: 'event'
  get '/teams/batch/:id' => 'teams#batch', as: 'batch'

  get '/register' => 'users#register'
  post '/register' => 'users#post_register'

  get '/login/manual' => 'main#manual_login', as: 'manual_login'
  post '/login/manual' => 'main#manual_login'

  get '/api/me' => 'users#api_me'
  get '/api/exchange' => 'main#exchange_token'

  get '/legacy' => 'main#legacy'
  get '/legacy/oauth' => 'main#legacy_oauth'

  get '/hall_of_fame' => 'main#hall_of_fame'

  namespace :judge do
    root 'main#index'
    resources :awards
    post '/awards/:id' => 'awards#update'
  end

  namespace :admin do
    root 'main#index'
    get '/set_batch/:id' => 'main#set_batch', as: 'set_batch'
    get '/set_event/:id' => 'main#set_event', as: 'set_event'
    get '/event' => 'main#event', as: 'event'
    get '/batch' => 'main#batch', as: 'batch'
    get '/awards' => 'main#awards', as: 'awards'
    get '/scramble' => 'main#scramble', as: 'scramble'
  end

  resources :teams
  resources :users
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
end
