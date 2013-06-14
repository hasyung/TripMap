class Admin::AudioListCategoriesController < Admin::ApplicationController

    def index
    @models = AudioListCategory.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = AudioListCategory.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = AudioListCategory.new params[:audio_list_category]
    if @model.save
      redirect_to admin_audio_list_categories_path, notice: t('messages.commons.success')
    else
      render :new
    end
  end

  def edit
    @model = AudioListCategory.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = AudioListCategory.find params[:id]
    if @model.update_attributes params[:audio_list_category]
      redirect_to admin_audio_list_categories_path, notice: t('messages.commons.success')
    else
      render :edit
    end
  end

  def destroy
    @model = AudioListCategory.find params[:id]
    if @model.destroy
      redirect_to admin_audio_list_categories_path, notice: t('messages.commons.success')
    else
      redirect_to admin_audio_list_categories_path, alert: t('messages.commons.error')
    end
  end

end