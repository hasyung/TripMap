TripMap::Application.routes.draw do

  devise_for :users,
             :path => "",
             :path_names => { :sign_in => 'login', :sign_out => 'logout' },
             :skip => [:passwords, :registrations],
             :controllers => { :sessions => 'admin/sessions' }

  namespace :admin do
    root :to => 'home#index'
    
    resources :maps, :except => :show
    resources :provinces
    resources :places
    resources :scenics
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

end

namespace :v1 do
  resources :maps, :only => :index do
    resources :weathers, :only => :index
    post 'show', :on => :member
    resources :shares, :only => :create do
      post 'nearby', :on => :collection
      post 'current', :on => :collection
    end
  end
end

root :to => 'home#index'
end