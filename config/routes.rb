Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/superadmin', as: 'rails_admin'
  root 'main#index'

  get '/filter' => 'main#filter'
  get '/oauth/s5' => 'main#s5'
  get '/logout' => 'users#logout'
  get '/hall_of_fame' => 'main#hall_of_fame'

  get '/error' => 'main#intentional_error'

  scope 'teams', as: 'teams' do
    get '/mine' => 'teams#code'
    post '/mine' => 'teams#user_update'
    get '/join' => 'teams#join'
    get '/join/:code' => 'teams#join_link', as: 'join_link'
    post '/join' => 'teams#join_team'
    get '/leave' => 'teams#leave'
    post '/project' => 'teams#save_project'
  end

  get '/teams/batch/:batch_id/event/:id' => 'teams#event', as: 'event'
  get '/teams/batch/:id' => 'teams#batch', as: 'batch'

  scope 'login', as: 'login' do
    get '/' => 'users#login'
    get '/s5' => 'users#s5_login'
    post '/' => 'users#post_login'
    get '/manual' => 'main#manual_login', as: 'manual'
    post '/manual' => 'main#manual_login'
  end

  scope 'register', as: 'register' do
    get '/' => 'users#register'
    post '/' => 'users#post_register'
  end

  scope 'api', as: 'api' do
    get '/me' => 'users#api_me'
    get '/exchange' => 'main#exchange_token'
    post '/slack/:id' => 'main#slack_hook', as: 'slack_hook'
  end

  scope 'legacy', as: 'legacy' do
    get '/' => 'main#legacy'
    get '/oauth' => 'main#legacy_oauth'
  end

  namespace :judge do
    root 'main#index'
    resources :awards
    post '/awards/:id' => 'awards#update'
  end

  namespace :volunteer do
    root 'main#index'
    resources :awards
    resources :teams
    post '/awards/:id' => 'awards#update'
  end

  namespace :admin do
    root 'main#index'
    get '/set_batch/:id' => 'main#set_batch', as: 'set_batch'
    get '/set_event/:id' => 'main#set_event', as: 'set_event'
    get '/event' => 'main#event', as: 'event'
    get '/batch' => 'main#batch', as: 'batch'
    get '/awards' => 'main#awards', as: 'awards'
    get '/awards/seed' => 'main#seed_awards', as: 'seed_awards'
    get '/scramble' => 'main#scramble', as: 'scramble'
    post '/inject' => 'main#inject', as: 'inject'
  end

  namespace :integration do
    root 'main#index'
    get '/slack' => 'slack#index'
    patch '/slack' => 'slack#update_token'
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
