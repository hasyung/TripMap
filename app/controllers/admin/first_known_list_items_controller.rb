class Admin::FirstKnownListItemsController < Admin::ApplicationController

  def index
    parent = FirstKnownList.find params[:first_known_list_id].to_i
    @models = parent.first_known_list_items.page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = FirstKnownListItem.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new

    @model = FirstKnownListItem.new params[:first_known_list_item]
    if @model.save
      redirect_to admin_first_known_first_known_list_first_known_list_items_path(@model.first_known_list.first_known_id, @model.first_known_list_id),
                  notice: t('messages.commons.success')
    else
      render :new
    end
  end

  def edit
    @model = FirstKnownListItem.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit

    @model = FirstKnownListItem.find params[:id]
    if @model.update_attributes params[:first_known_list_item]
      redirect_to admin_first_known_first_known_list_first_known_list_items_path(@model.first_known_list.first_known_id, @model.first_known_list_id),
                  notice: t('messages.commons.success')
    else
      render :edit
    end
  end

  def destroy
    @model = FirstKnownListItem.find params[:id]
    if @model.destroy
      redirect_to admin_first_known_first_known_list_first_known_list_items_path, notice: t('messages.commons.success')
    else
      redirect_to admin_first_known_first_known_list_first_known_list_items_path, alert: t('messages.commons.error')
    end
  end

end