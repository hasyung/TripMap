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
          get    'imagelists/:id/edit' => 'recommend_detaileds#edit_imagelist', :as => 'imagelist_edit' 

          get    'text/new'  => 'recommend_detaileds#new_text'
          post   'texts'     => 'recommend_detaileds#create_text'
          put    'text/:id'  => 'recommend_detaileds#update_text',  :as => 'text'
          delete 'text/:id'  => 'recommend_detaileds#destroy_text'
          get    'text/:id/edit' => 'recommend_detaileds#edit_text', :as => 'text_edit' 

          
        end
      end
    end
    resources :shares do
      get 'publish/:status', :action => :publish, :on => :member, :as => :publish
      post 'select', :on => :collection
    end

end

root :to => 'home#index'
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end