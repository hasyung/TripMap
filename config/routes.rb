TripMap::Application.routes.draw do

  devise_for :users,
             :path => "",
             :path_names => { :sign_in => 'login', :sign_out => 'logout' },
             :skip => [:passwords, :registrations],
             :controllers => { :sessions => 'admin/sessions' }

  resources :accounts, only: [] do
    get 'new/:device_id' => 'accounts#new', as: 'new', on: :collection
    post ':device_id' => 'accounts#create', as: '', on: :collection
    get 'success' => 'accounts#success', on: :collection
  end
  
  namespace :admin do
    root :to => 'home#index'
    resources :maps, :except => :show do
      resources :images, except: :show
    end

    resources :provinces, :except => :show
    resources :places, :except => :show do
      resources :images, except: :show
    end
    resources :scenics, :except => :show do
      resources :images, except: :show
    end
    resources :serialnumbers, :except => :show do
      get  'search',    on: :collection
      get  'export',    on: :collection
      post 'ex_search', on: :collection

    end
    
    resources :recommends do
      resources :recommend_records,
                path: 'records',:as => "records" do
        resources :recommend_detaileds, path: 'detaileds', :as => "detaileds" do
          get    'video/new'  => 'recommend_detaileds#new_video'
          post   'videos'     => 'recommend_detaileds#create_video'
          put    'video/:id'  => 'recommend_detaileds#update_video',  :as => 'video'
          delete 'video/:id'  => 'recommend_detaileds#destroy_video'
          get    'videos/:id/edit' => 'recommend_detaileds#edit_video', :as => 'video_edit'

          get    'audio/new'  => 'recommend_detaileds#new_audio'
          post   'audios'     => 'recommend_detaileds#create_audio'
          put    'audio/:id'  => 'recommend_detaileds#update_audio',  :as => 'audio'
          delete 'audio/:id'  => 'recommend_detaileds#destroy_audio'
          get    'audios/:id/edit' => 'recommend_detaileds#edit_audio', :as => 'audio_edit'

          get    'image/new'  => 'recommend_detaileds#new_image'
          post   'images'     => 'recommend_detaileds#create_image'
          put    'image/:id'  => 'recommend_detaileds#update_image',  :as => 'image'
          delete 'image/:id'  => 'recommend_detaileds#destroy_image'
          get    'images/:id/edit' => 'recommend_detaileds#edit_image', :as => 'image_edit'

          get    'imagelist/new'  => 'recommend_detaileds#new_imagelist'
          post   'imagelists'     => 'recommend_detaileds#create_imagelist'
          put    'imagelist/:id'  => 'recommend_detaileds#update_imagelist',  :as => 'imagelist'
          delete 'imagelist/:id'  => 'recommend_detaileds#destroy_imagelist'
          get    'imagelists/:id/edit'   => 'recommend_detaileds#edit_imagelist', :as => 'imagelist_edit'

          get    'imagelist/:id/images/'  => 'recommend_detaileds#images', :as => 'imageslist'
          post   'imagelist/:image_id/images'   => 'recommend_detaileds#create_images'
          put    'imagelist/:image_id/image/:id' => 'recommend_detaileds#update_images', :as => 'photos'
          delete 'imagelist/:image_id/image/:id' => 'recommend_detaileds#destroy_images'
          get    'imagelist/:image_id/image/:id/edit' => 'recommend_detaileds#edit_images', :as => 'edit_images'
          get    'imagelist/:image_id/image/new' => 'recommend_detaileds#new_images', :as => 'new_images'

          get    'text/new'  => 'recommend_detaileds#new_text'
          post   'texts'     => 'recommend_detaileds#create_text'
          put    'text/:id'  => 'recommend_detaileds#update_text',  :as => 'text'
          delete 'text/:id'  => 'recommend_detaileds#destroy_text'
          get    'text/:id/edit' => 'recommend_detaileds#edit_text', :as => 'text_edit'

        end
      end
    end
    resources :infos, :except => :show
    resources :shares do
      get 'publish/:status', :action => :publish, :on => :member, :as => :publish
      match 'select', :on => :collection, :via => [:get, :post]
    end
    resources :logs, :only => :index do
      match 'select', :on => :collection, :via => [:get, :post]
    end
    resources :accounts, :except => :show do
      get 'search', :on => :collection
    end
    
    resources :api, :only => [] do
      get 'v1', :on => :collection
    end

    match 'declaration/show' => 'declarations#show', :as => 'declaration', :via => [:get, :post, :put]
  end
  
  namespace :api do
    namespace :v1 do
      resources :maps, :only => :index do
        resources :weathers, :only => :index
        get '/show', :on => :collection
        get '/validate', :on => :collection
        get 'shares/nearby' => 'shares#nearby', :on => :collection
        get 'shares/current' => 'shares#current', :on => :collection
        post 'shares/create' => 'shares#create', :on => :collection
        post 'logs' => 'logs#create', :on => :collection
        get 'version' => 'maps#version', :on => :member
      end
      resources :accounts, only: [] do
        post '/create' => 'accounts#create', on: :collection
        post '/login' => 'accounts#login', on: :collection
        post '/validate' => 'accounts#validate', on: :collection
        get '/show' => 'accounts#show', on: :collection
      end
      resources :declarations, only: [] do
        get '/show' => 'declarations#show', on: :collection
      end
    end
  end
  
  root :to => 'home#index'
end