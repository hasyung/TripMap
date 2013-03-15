TripMap::Application.routes.draw do

  devise_for :users,
             :path => "",
             :path_names => { :sign_in => 'login', :sign_out => 'logout' },
             :skip => [:passwords, :registrations],
             :controllers => { :sessions => 'admin/sessions' }
             

  get "scenics/index"

  get "places/index"

  namespace :admin do
    root :to => 'home#index'
    
    resources :maps, :except => :show
    resources :provinces
    resources :places
    resources :scenics
    resources :shares do
      get 'publish/:status', :action => :publish, :on => :member, :as => :publish
      post 'select', :on => :collection
    end
end

namespace :v1 do
  resources :maps, :only => [:index, :show] do
    post 'validate', :on => :collection
    resources :shares, :only => :create do
      post 'nearby', :on => :collection
      post 'current', :on => :collection
    end
  end
end

root :to => 'home#index'
end