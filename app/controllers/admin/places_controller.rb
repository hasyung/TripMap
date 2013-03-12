class Admin::PlacesController < Admin::ApplicationController
  def index
    @places = Place.page(params[:page]).per(Setting.page_size)
    add_breadcrumb :index
  end

  def new
    @place = Place.new
    @place_icon  = @place.build_place_icon
    @place_image = @place.build_place_image
    @place_description_image = @place.build_place_description_image
    @place_audio = @place.build_place_audio
    @place_video = @place.build_place_video
    @place_description = @place.build_place_description
    add_breadcrumb :new
  end

  def edit
    @place = Place.find params[:id]
    @place_icon  = @place.place_icon
    @place_image = @place.place_image
    @place_description_image = @place.place_description_image
    @place_audio = @place.place_audio
    @place_video = @place.place_video
    @place_description = @place.place_description
    add_breadcrumb :edit
  end

  def create
    @place = Place.new params[:place]
    binding.pry
    if @place.save
      redirect_to admin_places_path, notice: t('messages.places.success')
    else
      redirect_to :new
    end
  end

  def update
    @place = Place.find params[:place]
    if @place.update_attributes
      redirect_to admin_places_path, notice: t('messages.places.success')
    else
      redirect_to :edit
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
