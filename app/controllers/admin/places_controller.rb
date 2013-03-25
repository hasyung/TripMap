class Admin::PlacesController < Admin::ApplicationController
  def index
    @places = Place.page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @place = Place.new

    add_breadcrumb :new
  end

  def edit
    @place = Place.find params[:id]

    add_breadcrumb :edit
  end

  def create
    @place = Place.new params[:place]
    if @place.save
      redirect_to admin_places_path, notice: t('messages.places.success')
    else
      render :new
    end
  end

  def update
    @place = Place.find params[:id]
    if @place.update_attributes params[:place]
      redirect_to admin_places_path, notice: t('messages.places.success')
    else
      render :edit
    end
  end

  def destroy
    @place = Place.find params[:id]
    if @place.destroy
      redirect_to admin_places_path, notice: t('messages.places.success')
    else
      redirect_to admin_places_path, notice: t('messages.places.error')
    end
  end

  

end
