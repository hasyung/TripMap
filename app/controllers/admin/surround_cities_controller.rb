class Admin::SurroundCitiesController < Admin::ApplicationController

  def index
    @surround_cities = SurroundCity.page(params[:page]).per(Setting.page_size)
    add_breadcrumb :index
  end

  def new
    @surround_city = SurroundCity.new
    add_breadcrumb :new
  end

  def create
    @surround_city = SurroundCity.new params[:surround_city]
    if @surround_city.save
      redirect_to admin_surround_cities_path, :notice => t('messages.infos.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @surround_city = SurroundCity.find params[:id]
    add_breadcrumb :edit
  end

  def update
    @surround_city = SurroundCity.find params[:id]

    if @surround_city.update_attributes params[:surround_city]
      redirect_to admin_surround_cities_path , :notice => t('messages.infos.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end

  def destroy
    @surround_city = SurroundCity.find params[:id]
    if @surround_city.destroy
      redirect_to admin_surround_cities_path, :notice => t('messages.infos.success')
    else
      redirect_to admin_surround_cities_path, :notice => t('messages.infos.error')
    end
  end

end