Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'errors/not_found'

  get 'errors/internal_server_error'

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search
  root 'home#index'

  # Routes for main resources
  resources :camps
  resources :instructors
  resources :locations
  resources :curriculums
  resources :users
  resources :registrations
  resources :families
  resources :sessions
  resources :students
  resources :carts
  
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  # get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  # routes for managing passwords
  get 'instructors/:id/change_pass' => 'instructors#change_pass', :as => :edit_instructor_password
  get 'families/:id/change_pass' => 'families#change_pass', :as => :edit_family_password

  # Routes for managing camp instructors
  get 'camps/:id/instructors', to: 'camps#instructors', as: :camp_instructors
  post 'camps/:id/instructors', to: 'camp_instructors#create', as: :create_instructor
  delete 'camps/:id/instructors/:instructor_id', to: 'camp_instructors#destroy', as: :remove_instructor
  
  # Routes for managing registrations
  get 'camps/:id/students', to: 'camps#students', as: :camp_students
  get 'camps/:id/students/add', to: 'carts#add_to_cart', as: :add_to_cart
  post 'camps/:id/students', to: 'registrations#create', as: :create_registration
  delete 'camps/:id/students/:student_id', to: 'registrations#destroy', as: :remove_registration
  
  # Routes for managing carts
  delete "carts/delete_from_cart/:camp_id/:student_id" => "carts#delete_from_cart", as: :delete_from_cart
  post "carts/checkout", to: "carts#checkout", as: :checkout
  
  # error routes
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

end
