Ezslp3::Application.routes.draw do
  root :to => "static_pages#about"
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}, via: [:get]
  match   'visits/search_visits_by_date'  => 'visits#search_visits_by_date', via: [:get]
  match   'visits/search_visits_by_patient_authorization'  => 'visits#search_visits_by_patient_authorization', via: [:get]
  resources :visits
  resources :searchs
  resources :patient_authorizations do
    resources :visits
  end
  match   'patients/search'  => 'patients#search', via: [:get]
  resources :patients
  devise_for :users
  devise_scope :user do
    get '/logout' => 'devise/sessions#destroy'
  end

  resources :token_authentications, :only => [:create, :destroy]
  resources :user, :controller => "user"
  resources :dashboard

  match   'about'  => 'static_pages#about', via: [:get]
  match   'contact'  => 'static_pages#contact', via: [:get]
  match   'login'  => 'static_pages#login', via: [:get]
  match   'register'  => 'static_pages#register', via: [:get]
  match   'screencasts'  => 'static_pages#screencasts', via: [:get]
  match   'home'  => 'static_pages#home', via: [:get]
  match   'help'  => 'static_pages#help', via: [:get]
  match   'slp-app-integration'  => 'static_pages#slp-app-integration', via: [:get]

  #This redirects all invalid pages to 'home' for authenticated users
  match '*path', :controller => 'static_pages', :action => 'invalid_route', via: [:get]

end
