class Admin::FirstKnownListsController < Admin::ApplicationController

  def index
    parent = FirstKnown.find params[:first_known_id].to_i
    @models = parent.first_known_lists.page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = FirstKnownList.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = FirstKnownList.new params[:first_known_list]
    if @model.save
      redirect_to admin_first_known_first_known_lists_path, notice: t('messages.commons.success')
    else
      render :new
    end
  end

  def edit
    @model = FirstKnownList.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = FirstKnownList.find params[:id]
    if @model.update_attributes params[:first_known_list]
      redirect_to admin_first_known_first_known_lists_path(@model.first_known_id), notice: t('messages.commons.success')
    else
      render :edit
    end
  end

  def destroy
    @model = FirstKnownList.find params[:id]
    if @model.destroy
      redirect_to admin_first_known_first_known_lists_path, notice: t('messages.commons.success')
    else
      redirect_to admin_first_known_first_known_lists_path, alert: t('messages.commons.error')
    end
  end

end