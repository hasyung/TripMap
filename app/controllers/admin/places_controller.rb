class Admin::PlacesController < Admin::ApplicationController
  def index
    @places = Place.page(params[:page]).per(Setting.page_size)

    add_breadcrumb :index
  end

  def new
    @place = Place.new
    build_info @place

    add_breadcrumb :new
  end

  def edit
    @place = Place.find params[:id]
    build_info_and_valid @place

    add_breadcrumb :edit
  end

  def create
    @place = Place.new params[:place]
    if @place.save
      redirect_to admin_places_path, notice: t('messages.places.success')
    else
      build_info_and_valid @place
      render :new
    end
  end

  def update
    @place = Place.find params[:id]
    # binding.pry
    if @place.update_attributes params[:place]
      redirect_to admin_places_path, notice: t('messages.places.success')
    else
      build_info_and_valid @place
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

  def build_info place
    @place_icon  = place.build_place_icon
    @place_image = place.build_place_image
    @place_description_image = place.build_place_description_image
    @place_audio = place.build_place_audio
    @place_video = place.build_place_video
    @place_description = place.build_place_description
  end

  def build_info_and_valid place
    @place_icon  = place.build_place_icon if !@place_icon = place.place_icon
    @place_image = place.build_place_image if !@place_image = place.place_image
    @place_description_image = place.build_place_description_image if !@place_description_image = place.place_description_image
    @place_audio = place.build_place_audio if !@place_audio = place.place_audio
    @place_video = place.build_place_video if !@place_video = place.place_video
    @place_description = place.build_place_description if !@place_description = place.place_description
  end

end
