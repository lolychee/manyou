Manyou::Application.routes.draw do

  root :to => 'home#index'

  get   :latest,   :to => 'home#latest',  :as => :latest_home

  match "/uploads/*path" => "gridfs#serve"

  scope :module => :member do

    get     :login,     :to => 'sessions#new',      :as => :new_session
    post    :login,     :to => 'sessions#create',   :as => :session
    get     :logout,    :to => 'sessions#destroy',  :as => :destroy_session

    resource :account

    resources :users, :only => [:index, :new, :create, :tagged] do
      collection do
        get 'tagged/:key', :action => :tagged, :constraints => { :key => /[^\/]+/ }, :as => :tagged
      end
    end

    resources :users, :path => :user, :except => [:index, :new, :create, :tagged] do
      member do
        get :follow
        get :unfollow
      end
    end

    get 'bookmarks/add*path' => 'bookmarks#create',    :as => :create_bookmark
    get 'bookmarks/del*path' => 'bookmarks#destroy',   :as => :destroy_bookmark

  end

  scope :module => :forum do

    resource :search

    resources :nodes, :only => [:index, :new, :create, :tagged] do
      collection do
        get 'tagged/:key',  :action => :tagged, :constraints => { :key => /[^\/]+/ },   :as => :tagged
      end
    end

    resources :nodes, :path => :node, :except => [:index, :new, :create, :tagged] do
    end

    resources :topics, :only => [:index, :new, :create, :tagged] do
      collection do
        get 'tagged/:key',  :action => :tagged, :constraints => { :key => /[^\/]+/ },   :as => :tagged
      end
    end
    resources :topics, :path => :topic, :except => [:index, :new, :create, :tagged] do
      member do
        get :voteup
        get :votedown
        get :follow
        get :unfollow
      end

      resources :replies do
        member do
          get :voteup
          get :votedown
        end
      end
    end

  end

  namespace :dashboard do
    root :to => 'home#index'

    resources :users, :topics, :tags, :settings
  end

  match '*path', :to => 'errors#routing'

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
