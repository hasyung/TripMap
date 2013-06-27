class Admin::InfoListsController < Admin::ApplicationController

  def index
    @info_lists = InfoList.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @info_list = InfoList.new
    add_breadcrumb :new
  end

  def create
    @info_list = InfoList.new params[:info_list]
    if @info_list.save
      set_slug(params[:info_list][:slug], @info_list.info_list_slugs)
      redirect_to admin_info_lists_path, :notice => t('messages.info_lists.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @info_list = InfoList.find params[:id]
    @info_list.slug = Keyword.get_slug(@info_list.info_list_slugs)
    add_breadcrumb :edit
  end

  def update
    @info_list = InfoList.find params[:id]
    set_slug(params[:info_list][:slug], @info_list.info_list_slugs)
    if @info_list.update_attributes params[:info_list]
      redirect_to admin_info_lists_path, :notice => t('messages.info_lists.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end

  def destroy
    @info_list = InfoList.find params[:id]
    if @info_list.destroy
      redirect_to admin_info_lists_path, :notice => t('messages.info_lists.success')
    else
      redirect_to admin_info_lists_path, :alert => t('messages.info_lists.error')
    end
  end

end