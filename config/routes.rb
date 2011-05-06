Manyou::Application.routes.draw do

  root :to => 'topics/topics#index'
  match "/uploads/*path" => "gridfs#serve"

  scope :module => :users do
    get   'login',    :to => 'sessions#new',        :as => :new_session
    post  'login',    :to => 'sessions#create',     :as => :session
    get   'logout',   :to => 'sessions#destroy',    :as => :destroy_session

    get   'signup',   :to => 'accounts#new',        :as => :new_account
    post  'signup',   :to => 'accounts#create',     :as => :create_account
    get   'account',  :to => 'accounts#edit',       :as => :edit_account
    put   'account',  :to => 'accounts#update',     :as => :account

    get   'accounts/forget',  :to => 'forget#new',      :as => :new_forget
    post  'accounts/forget',  :to => 'forget#create',   :as => :forget
    get   'accounts/reset',   :to => 'forget#edit',     :as => :edit_forget
    put   'accounts/reset',   :to => 'forget#update',   :as => :forget

    resources :users, :only => [:index, :tagged] do
      collection do
        get 'tagged/:key',  :action => :tagged, :constraints => { :key => /[^\/]+/ },   :as => :tagged
      end
    end
    resources :users, :path => :user, :only => [:show] do
    end

  end

  scope :module => :topics do

    get "node/:key", :to => 'topics#tagged', :constraints  => { :key => /[^\/]+/ }, :as => :node
    resources :topics, :only => [:index, :new, :create, :tagged] do
      collection do
        get "tagged/:key",:action => 'tagged', :constraints  => { :key => /[^\/]+/ }, :as => :tagged
      end
    end
    resources :topics, :path => 'topic', :except => [:index, :new, :create] do
      resources :replies do
        member do
          get :agree
        end
      end
      member do
        get :like
        get :unlike
        get :mark
        get :unmark
      end
    end

  end

  scope :module => :tags do

    resources :tags, :path => :tag, :constraints  => { :id => /[^\/]+/ }, :only => [:show] do
      resources :topics, :only => [:index, :new, :create, :tagged]
    end

  end


  match '*path', :to => 'errors#routing'

end
