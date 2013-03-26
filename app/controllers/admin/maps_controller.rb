class Admin::MapsController < Admin::ApplicationController
  
  def index
    @maps = Map.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @map = Map.new
    add_breadcrumb :new
  end
  
  def create
    @map = Map.new params[:map]
    if @map.save
      redirect_to admin_maps_path, :notice => t('messages.maps.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @map = Map.find params[:id]
    @images = @map.map_slides.order_asc
    add_breadcrumb :edit
  end
  
  def update
    @map = Map.find params[:id]
    if @map.update_attributes params[:map]
      redirect_to admin_maps_path, :notice => t('messages.maps.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end
  
  def destroy
    @map = Map.find params[:id]
    if @map.destroy
      redirect_to admin_maps_path, :notice => t('messages.maps.success')
    else
      redirect_to admin_maps_path, :notice => t('messages.maps.error')
    end
  end

  def new_image
    @image = Image.new

    add_breadcrumb :new_image
  end

  def create_image
    map = Map.find params[:map_id]
    @image = map.map_slides.new params[:image]
    if @image.save
      redirect_to edit_admin_map_path(params[:map_id]), :notice => t('messages.maps.images.success')
    else
      redirect_to edit_admin_map_path(params[:map_id]), :notice => t('messages.maps.images.error')
    end
  end

  def edit_image
    @image = Image.find params[:id]

    add_breadcrumb :edit_image
  end

  def update_image
    map = Map.find params[:map_id]
    @image = map.map_slides.find params[:id]
    if @image.update_attributes params[:image]      
      redirect_to edit_admin_map_path(params[:map_id]), :notice => t('messages.maps.images.success')
    else
      redirect_to edit_admin_map_path(params[:map_id]), :notice => t('messages.maps.images.error')
    end
  end

  def destroy_image
    map = Map.find params[:map_id]
    @image = map.map_slides.find params[:id]    
    if @image.destroy      
      redirect_to edit_admin_map_path(params[:map_id]), :notice => t('messages.maps.images.success')
    else
      redirect_to edit_admin_map_path(params[:map_id]), :notice => t('messages.maps.images.error')
    end
  end
end