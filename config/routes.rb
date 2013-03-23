TripMap::Application.routes.draw do

  devise_for :users,
             :path => "",
             :path_names => { :sign_in => 'login', :sign_out => 'logout' },
             :skip => [:passwords, :registrations],
             :controllers => { :sessions => 'admin/sessions' }

  namespace :admin do
    root :to => 'home#index'
    resources :maps, :except => :show do
      get 'image/new'    => 'maps#new_image'
      post 'images'      => 'maps#create_image'
      put 'image/:id'    => 'maps#update_image', :as => "image"
      delete 'image/:id' => 'maps#destroy_image'
      get 'images/:id/edit' => 'maps#edit_image', :as => "image_edit"
    end

    resources :provinces
    resources :places
    resources :scenics
    resources :serialnumbers, :except => :show do
      post 'search', on: :collection
    end
    get 'serialnumbers/export' => "serialnumbers#export", :as => "serialnumbers_export"
    
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
      post 'select', :on => :collection
    end
    resources :logs, :only => :index do
      post 'select', :on => :collection
    end
    
    resources :api, :only => [] do
      get 'v1', :on => :collection
    end
  end
  
  namespace :v1 do
    resources :maps, :only => :index do
      resources :weathers, :only => :index
      post '/show', :on => :collection
      post 'shares/nearby' => 'shares#nearby', :on => :collection
      post 'shares/current' => 'shares#current', :on => :collection
      post 'shares/create' => 'shares#create', :on => :collection
      post 'logs' => 'logs#create', :on => :collection
      get 'version' => 'maps#version', :on => :member
    end
  end
  
  root :to => 'home#index'
end