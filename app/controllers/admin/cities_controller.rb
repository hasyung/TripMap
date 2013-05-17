class Admin::CitiesController < Admin::ApplicationController

  def index
    @cities = City.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @city = City.new
    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @city = City.new params[:city]
    if @city.save
      redirect_to admin_cities_path, notice: t('messages.cities.success')
    else
      render :new
    end
  end

  def edit
    @city = City.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @city = City.find params[:id]
    if @city.update_attributes params[:city]
      redirect_to admin_cities_path , notice: t('messages.cities.success')
    else
      render :edit
    end
  end

  def destroy
    @city = City.find params[:id]
    if @city.destroy
      redirect_to admin_cities_path , notice: t('messages.cities.success')
    else
      redirect_to admin_cities_path , alert: t('messages.cities.error')
    end
  end

end