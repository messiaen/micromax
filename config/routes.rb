Budget::Application.routes.draw do
  resources :profiles

  resources :people

  resources :accounts

  resources :transactions
  resources :expenses
  resources :incomes
  resources :withdraws
  resources :deposits
  
  resource :sessions, :only => [:new, :create, :destroy]
  
  match "/expenses/:id" => "transactions#show"
  
  match "/accounts/:id/withdraw" => "accounts#withdraw"
  match "/accounts/:id/make_withdraw" => "accounts#make_withdraw"
  match "/accounts/:id/deposit" => "accounts#deposit"
  match "/accounts/:id/make_deposit" => "accounts#make_deposit"
  match "/accounts/:id/add_remove_users" => "accounts#add_remove_users"
  match "/accounts/:id/get_transactions" => "accounts#get_transactions"
  
  match "/admin" => "admin#admin"
  match "/admin/update_accounts_users" => "admin#update_accounts_users"
  match "/admin/edit_account" => "admin#edit_account"
  
  match "/people/:id/edit_password" => "people#edit_password"
  match "/people/:id/update_password" => "people#update_password"
  
  
  match "/login" => "sessions#new", :as => "login"
  match "/logout" => "sessions#destroy", :as => "logout"

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
  root :to => 'sessions#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
