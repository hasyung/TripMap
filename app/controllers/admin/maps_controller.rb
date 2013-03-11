class Admin::MapsController < Admin::ApplicationController
  
  def index
    @maps = Map.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    add_breadcrumb :new
    @map = Map.new
    @cover = @map.build_cover
    @plat = @map.build_plat
    @description = @map.build_description
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
    @cover = @map.cover
    @plat = @map.plat
    @description = @map.description
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
end