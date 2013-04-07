class Admin::MapsController < Admin::ApplicationController
  
  def index
    @maps = Map.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @model = Map.new
    add_breadcrumb :new
  end
  
  def create
    @model = Map.new params[:map]
    if @model.save
      redirect_to admin_maps_path, :notice => t('messages.maps.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @model = Map.find params[:id]
    @images = @model.map_slides.order_asc
    add_breadcrumb :edit
  end
  
  def update
    @model = Map.find params[:id]
    if @model.update_attributes params[:map]
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
end