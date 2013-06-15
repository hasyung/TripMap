class Admin::AudioListsController < Admin::ApplicationController

  def index
    parent = AudioListCategory.find params[:audio_list_category_id].to_i
    @models = parent.audio_lists.page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = AudioList.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = AudioList.new params[:audio_list]
    if @model.save
      redirect_to admin_audio_list_category_audio_lists_path, notice: t('messages.commons.success')
    else
      render :new
    end
  end

  def edit
    @model = AudioList.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = AudioList.find params[:id]
    if @model.update_attributes params[:audio_list]
      redirect_to admin_audio_list_category_audio_lists_path(@model.audio_list_category_id), notice: t('messages.commons.success')
    else
      render :edit
    end
  end

  def destroy
    @model = AudioList.find params[:id]
    if @model.destroy
      redirect_to admin_audio_list_category_audio_lists_path, notice: t('messages.commons.success')
    else
      redirect_to admin_audio_list_category_audio_lists_path, alert: t('messages.commons.error')
    end
  end

end