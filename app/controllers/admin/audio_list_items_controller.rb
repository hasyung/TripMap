class Admin::AudioListItemsController < Admin::ApplicationController

  def index
    parent = AudioList.find params[:audio_list_id].to_i
    @models = parent.audio_list_items.page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = AudioListItem.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new

    @model = AudioListItem.new params[:audio_list_item]
    if @model.save
      redirect_to admin_audio_list_category_audio_list_audio_list_items_path(@model.audio_list.audio_list_category_id, @model.audio_list_id),
                  notice: t('messages.commons.success')
    else
      render :new
    end
  end

  def edit
    @model = AudioListItem.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit

    @model = AudioListItem.find params[:id]
    if @model.update_attributes params[:audio_list_item]
      redirect_to admin_audio_list_category_audio_list_audio_list_items_path(@model.audio_list.audio_list_category_id, @model.audio_list_id),
                  notice: t('messages.commons.success')
    else
      render :edit
    end
  end

  def destroy
    @model = AudioListItem.find params[:id]
    if @model.destroy
      redirect_to admin_audio_list_category_audio_list_audio_list_items_path, notice: t('messages.commons.success')
    else
      redirect_to admin_audio_list_category_audio_list_audio_list_items_path, alert: t('messages.commons.error')
    end
  end

end