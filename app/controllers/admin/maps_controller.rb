class Admin::MapsController < Admin::ApplicationController
  
  def index
    @maps = Map.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    add_breadcrumb :new
    @map = Map.new
    @map_cover = @map.build_map_cover
    @map_plat = @map.build_map_plat
    @map_description = @map.build_map_description
  end
  
  def create
    add_breadcrumb :new
    @map = Map.new params[:map]
    if @map.save
      redirect_to admin_maps_path, :notice => t('messages.maps.success')
    else
       @map_cover = @map.build_map_cover
       @map_plat = @map.build_map_plat
       @map_description = @map.build_map_description
      render :new
    end
  end

  def edit
    @map = Map.find params[:id]
    @map_cover = @map.build_map_cover if !@map_cover = @map.map_cover
    @map_plat = @map.build_map_plat if !@map_plat = @map.map_plat
    @map_description = @map.build_map_description if !@map_description = @map.map_description
    add_breadcrumb :edit
  end
  
  def update
    add_breadcrumb :edit
    @map = Map.find params[:id]
    if @map.update_attributes params[:map]
      redirect_to admin_maps_path, :notice => t('messages.maps.success')
    else
      @map_cover = @map.build_map_cover if !@map_cover = @map.map_cover
      @map_plat = @map.build_map_plat if !@map_plat = @map.map_plat
      @map_description = @map.build_map_description if !@map_description = @map.map_description
      render :edit
    end
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