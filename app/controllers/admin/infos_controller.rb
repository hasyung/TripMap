class Admin::InfosController < Admin::ApplicationController

  def index
    info_list = InfoList.find params[:info_list_id].to_i
    @infos = info_list.infos.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @info = Info.new
    add_breadcrumb :new
  end

  def create
    @info = Info.new params[:info]
    if @info.save
      set_slug(params[:info][:slug], @info.info_slugs)
      redirect_to admin_info_list_infos_path, :notice => t('messages.infos.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @info = Info.find params[:id]
    @info.slug = Keyword.get_slug(@info.info_slugs)
    add_breadcrumb :edit
  end

  def update
    @info = Info.find params[:id]
    set_slug(params[:info][:slug], @info.info_slugs)
    if @info.update_attributes params[:info]
      redirect_to admin_info_list_infos_path(@info.info_list_id), :notice => t('messages.infos.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end

  def destroy
    @info = Info.find params[:id]
    if @info.destroy
      redirect_to admin_info_list_infos_path, :notice => t('messages.infos.success')
    else
      redirect_to admin_info_list_infos_path, :alert => t('messages.infos.error')
    end
  end

end