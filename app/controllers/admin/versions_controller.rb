class Admin::VersionsController < Admin::ApplicationController

  def index
    @versions = Version.page(params[:page]).per(Setting.page_size)
    add_breadcrumb :index
  end

  def new
    @version = Version.new
    add_breadcrumb :new
  end

  def create
    @version = Version.new params[:version]
    if @version.save
      redirect_to admin_versions_path, :notice => t('messages.infos.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @version = Version.find params[:id]
    add_breadcrumb :edit
  end

  def update
    @version = Version.find params[:id]

    if @version.update_attributes params[:version]
      redirect_to admin_versions_path , :notice => t('messages.infos.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end

  def destroy
    @version = Version.find params[:id]
    if @version.destroy
      redirect_to admin_versions_path, :notice => t('messages.infos.success')
    else
      redirect_to admin_versions_path, :alert => t('messages.infos.error')
    end
  end

end