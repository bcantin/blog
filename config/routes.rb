Blogcast::Application.routes.draw do
  root :to => "posts#index"

  resources :posts do
    resources :comments do
      collection do
        post :preview
      end
      member do
        delete :mark_as_spam
      end
    end
    
    resources :spams do
      collection do
        delete :incinerate
      end
      member do
        delete :mark_as_ham
      end
    end
  end
  
  resources :drafts
  
  match 'archives', :to => 'archives#index', :as => :archives, :via => [:get]
  
  match 'admin', :to => 'user_sessions#new', :as => :admin, :via => [:get]
  match 'logout', :to => 'user_sessions#destroy', :as => :logout, :via => [:delete]
  resource :user_sessions
  
  resources :users
  
  match 'sitemap', :to => 'sitemap#index', :via => [:get]
  
  match '*a', :to => 'errors#routing', :via => [:get]
end
