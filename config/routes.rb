MurdererGame::Application.routes.draw do

  get "oauth/init_default"

  get "oauth/callback_default"

  get "invitations/init_facebook_invite"

  get "invitations/facebook_invite_callback"

  get "invitations/email_invitation"

  get "index" => "pages#index", :as => "index"
  get "overview" => "pages#overview", :as => "overview"
  get "rules" => "pages#rules", :as => "rules"
  get "impressum" => "pages#impressum", :as => "impressum"
  get "invite" => "pages#invite", :as => "invite"
  get "about_us" => "pages#about_us", :as => "about_us"
  get "supporters" => "pages#supporters", :as => "supporters"
  get "reset_password" => "pages#password_reset", as: "password_reset"


  get "openid/begin"
  post "openid/begin"
  get "openid/complete"
  get "openid/login"
  get "openid/complete_registration"
  get "openid/begin_registration"

  get "games/open", :as => "open_games"
  get "games/:id/assign" => "games#assign", as: "new_assignment"
    get "assignments/:id/post" => "assignments#post", as: "post_assignment"
  get "games/:id/highscore" => "games#highscore", as: "highscore"
  get "contracts/:id/execute" => "contracts#execute", as: "contract_execution"
  get "contracts/:id/confirm" => "contracts#confirm", as: "contract_confirmation"
  get "users/:id/:game/suicide" => "users#suicide", as: "user_suicide"
  get "users/:id/disconnect_facebook" => "users#disconnect_facebook", as: "disconnect_facebook_user"
  get "contracts/:id/reject" => "contracts#reject", as: "contract_rejection"
  
  get "users/:token/activate" => "users#activate", as: "activation_confirmation"
  get "users/:id/snitch" => "users#snitch", as: "snitch_user"
  post "users/:id/snitch" => "users#snitch", as: "snitch_user"
  post "users/reset_password" => "users#reset_password", as: "reset_password_execute"

  
  get "sessions/new"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  root to: "pages#index"
  resources :users
  resources :sessions
  resources :games

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
