class Admin::BroadcastsController < Admin::ApplicationController

  def index
    @models = Broadcast.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = Broadcast.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = Broadcast.new params[:broadcast]
    if @model.save
      redirect_to admin_broadcasts_path, notice: t('messages.commons.success')
    else
      render :new
    end
  end

  def edit
    @model = Broadcast.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = Broadcast.find params[:id]
    if @model.update_attributes params[:broadcast]
      redirect_to admin_broadcasts_path, notice: t('messages.commons.success')
    else
      render :edit
    end
  end

  def destroy
    @model = Broadcast.find params[:id]
    if @model.destroy
      redirect_to admin_broadcasts_path, notice: t('messages.commons.success')
    else
      redirect_to admin_broadcasts_path, alert: t('messages.commons.error')
    end
  end

end