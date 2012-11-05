Ezslp3::Application.routes.draw do
  root :to => "static_pages#about"
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  match   'visits/search_visits_by_date'  => 'visits#search_visits_by_date'
  match   'visits/search_visits_by_patient_authorization'  => 'visits#search_visits_by_patient_authorization'
  resources :visits
  resources :searchs
  resources :patient_authorizations do
    resources :visits
  end
  match   'patients/search'  => 'patients#search'
  resources :patients
  devise_for :users
  devise_scope :user do
    get '/logout' => 'devise/sessions#destroy'
  end

  resources :token_authentications, :only => [:create, :destroy]
  resources :user, :controller => "user"
  resources :dashboard

  match   'about'  => 'static_pages#about'
  match   'contact'  => 'static_pages#contact'
  match   'login'  => 'static_pages#login'
  match   'register'  => 'static_pages#register'
  match   'screencasts'  => 'static_pages#screencasts'
  match   'home'  => 'static_pages#home'
  match   'help'  => 'static_pages#help'
  match   'slp-app-integration'  => 'static_pages#slp-app-integration'

  #This redirects all invalid pages to 'home' for authenticated users
  match '*path', :controller => 'static_pages', :action => 'invalid_route'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
