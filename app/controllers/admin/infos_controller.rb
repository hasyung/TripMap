class Admin::InfosController < Admin::ApplicationController
  
  def index
    @infos = Info.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @info = Info.new
    add_breadcrumb :new
  end
  
  def create
    @info = Info.new params[:info]
    if @info.save
      redirect_to admin_infos_path, :notice => t('messages.infos.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @info = Info.find params[:id]
    add_breadcrumb :edit
  end
  
  def update
    @info = Info.find params[:id]
    if @info.update_attributes params[:info]
      redirect_to admin_infos_path, :notice => t('messages.infos.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end
  
  def destroy
    @info = Info.find params[:id]
    if @info.destroy
      redirect_to admin_infos_path, :notice => t('messages.infos.success')
    else
      redirect_to admin_infos_path, :notice => t('messages.infos.error')
    end
  end
end