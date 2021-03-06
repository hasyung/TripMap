class Admin::ChildrenBroadcastsController < Admin::ApplicationController

  def index
    parent = Broadcast.find params[:broadcast_id].to_i
    @models = parent.children_broadcasts.page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = ChildrenBroadcast.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = ChildrenBroadcast.new params[:children_broadcast]
    if @model.save
      redirect_to admin_broadcast_children_broadcasts_path, notice: t('messages.commons.success')
    else
      render :new
    end
  end

  def edit
    @model = ChildrenBroadcast.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = ChildrenBroadcast.find params[:id]

    if @model.update_attributes params[:children_broadcast]
      redirect_to admin_broadcast_children_broadcasts_path(@model.broadcast_id), notice: t('messages.commons.success')
    else
      render :edit
    end
  end

  def destroy
    @model = ChildrenBroadcast.find params[:id]
    if @model.destroy
      redirect_to admin_broadcast_children_broadcasts_path, notice: t('messages.commons.success')
    else
      redirect_to admin_broadcast_children_broadcasts_path, alert: t('messages.commons.error')
    end
  end

end