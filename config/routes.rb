FBCPService::Application.routes.draw do

  resources :users
  resources :facebookposts, only: [:create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]

#  get "users/index"
#  get "users/new"
#  get "users/show"
#  get "users/create"

#  get "sessions/new"
#  get "sessions/create"
#  get "sessions/destroy"

#  get "facebookposts/create"
#  get "facebookposts/destroy"

#  get "facebooks/index"
#  get "facebooks/login"
#  get "facebooks/logout"

  root :to => "facebooks#index"

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/index',      to: 'facebooks#index'
  match '/login',      to: 'facebooks#login'
  match '/logout',     to: 'facebooks#logout'
  match '/callback',   to: 'facebooks#callback'
  match '/menu',       to: 'facebooks#menu'
  match '/posttowall',  to: 'facebooks#posttowall'
  match '/getposts',  to: 'facebooks#getposts'



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
