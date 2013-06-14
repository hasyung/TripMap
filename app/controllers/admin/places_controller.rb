class Admin::PlacesController < Admin::ApplicationController

  def index
    @places = Place.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = Place.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = Place.new params[:place]
    if @model.save
      redirect_to admin_places_path, notice: t('messages.places.success')
    else
      render :new
    end
  end

  def edit
    @model = Place.find params[:id]
    @images = @model.place_slides.order_asc
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = Place.find params[:id]
    if @model.update_attributes params[:place]
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
      redirect_to admin_places_path, alert: t('messages.places.error')
    end
  end

end