Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
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

  get 'instructors/:id/change_pass' => 'instructors#change_pass', :as => :edit_instructor_password
  get 'families/:id/change_pass' => 'families#change_pass', :as => :edit_family_password

  # Routes for managing camp instructors
  get 'camps/:id/instructors', to: 'camps#instructors', as: :camp_instructors
  post 'camps/:id/instructors', to: 'camp_instructors#create', as: :create_instructor
  delete 'camps/:id/instructors/:instructor_id', to: 'camp_instructors#destroy', as: :remove_instructor
  
  # Routes for managing registrations
  get 'camps/:id/students', to: 'camps#students', as: :camp_students
  get 'camps/:id/students/add', to: 'carts#add_to_cart', as: :add_to_cart
  delete 'camps/:id/students/:student_id', to: 'registrations#destroy', as: :remove_registration
  
  # Routes for managing carts
  
  # delete 'carts/', to: 'carts#destroy', as: :remove_cart_item
  delete "carts/delete_from_cart/:camp_id/:student_id" => "carts#delete_from_cart", as: :delete_from_cart
  # post "carts/checkout/:credit_card_num/:expiration_year/:expiration_month" => "carts#checkout", as: :checkout
  post "carts/checkout", to: "carts#checkout", as: :checkout
end
