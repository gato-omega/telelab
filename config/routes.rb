Telelab02::Application.routes.draw do

  resources :vlans

  resources :device_connections

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  resources :admins
  resources :technicians
  resources :students
  resources :teachers

  resources :courses

  resources :practicas

  resources :dispositivos
  resources :puertos

  resources :users

  scope '/api' do
    ### for that token_input_user works, used in "_form#practicas" view #####
    match '/users' => 'users#json_users', :as => 'json_users'
    #for that token_input_user works, used in "_form#puertos" view #####
    match '/puertos' => 'puertos#json_puertos', :as => 'json_puertos'
    ### for that event_calendar works #####
    match '/practicas' => 'practicas#practice_events', :as => 'json_practicas'
  end

  ### for display allowed devices, used in "_form#practicas" view #####
  match '/practicas/free_devices' => 'practicas#free_devices', :as => 'free_devices', :via => :post

  get '/practicas/:id/practica' => 'practicas#make_practice'

  devise_for :users, :path_prefix => 'account'

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  # Profiles edit, update and show
  get '/profile/:username/edit' => 'profiles#edit', :as => 'profile_edit'
  match '/profile/:id' => 'profiles#update', :via => :put
  get '/profile/:username' => 'profiles#show', :as => 'profile'

  #THIS IS HOMEPAGE
  get '/home' => 'home#index', :as => 'home'

  #DO ADMIN STUFF HERE
  scope '/admin' do
    get '/' => 'admin#index', :as => 'admin_home'
  end

  #DO TEACHER STUFF HERE
  scope '/teacher' do
    get '/' => 'teacher#index', :as => 'teacher_home'
  end

  #DO STUDENT STUFF HERE
  scope '/student' do
    get '/' => 'student#index', :as => 'student_home'
    match '/practicas' => 'student#practicas', :as => 'student_practicas'
  end

  #DO TECHNICIAN STUFF HERE
  scope '/technician' do
    get '/' => 'technician#index', :as => 'technician_home'
  end

  # IN LAB PRACTICE

  get "/practicas/:id/practica" => 'practicas#make_practice'
  # Javascript generator
  match "/practicas/:id/lab" => 'practicas#lab', :as => 'practica_lab'

  match "/practicas/:id/practica/terminal" => 'practicas#terminal', :as => 'practica_terminal', :via => :post
  match "/practicas/:id/practica/chat" => 'practicas#chat', :as => 'practica_chat', :via => :post
  match "/practicas/:id/practica/conexion" => 'practicas#conexion', :as => 'practica_conexion', :via => :post
  match "/practicas/:id/practica/chat_status" => 'practicas#chat_status', :as => 'practica_chat_status', :via => :post

  # JAVASCRIPT CONTROLLER
  scope '/javascript_engine' do
    match '/faye_init' => 'javascript#faye_init', :as => 'js_faye_init'
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
