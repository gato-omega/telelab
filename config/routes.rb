Telelab02::Application.routes.draw do

  devise_for :users, :path_prefix => 'account'

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end
  
  get '/profile/:username' => 'profiles#edit', :as => 'profile'
  match '/profile/:id' => 'profiles#update', :via => :put

  #THIS IS HOMEPAGE
  get '/home' => 'home#index', :as => 'home'

  #DO ADMIN STUFF HERE
  scope '/admin' do
    get '/' => 'admin#index', :as => 'admin_home'
    resources :courses
    resources :users
  end

  #DO CLIENT STUFF HERE
  scope '/teacher' do
    get '/' => 'teacher#index', :as => 'client_home'
  end

  #DO EMPLOYEE STUFF HERE
  scope '/student' do
    get '/' => 'student#index', :as => 'employee_home'
  end
  
  scope '/technician' do
    get '/' => 'technician#index', :as => 'employee_home'
  end

  
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
  root :to => 'pass_through#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
