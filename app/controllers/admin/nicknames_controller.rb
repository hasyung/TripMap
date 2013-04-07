class Admin::NicknamesController < Admin::ApplicationController
  def index
    @nicknames = Nickname.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @nickname = Nickname.new
    add_breadcrumb :new
  end
  
  def create
    @nickname = Nickname.new params[:nickname]
    if @nickname.save
      redirect_to admin_nicknames_path, :notice => t('messages.nicknames.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @nickname = Nickname.find params[:id]
    add_breadcrumb :edit
  end
  
  def update
    @nickname = Nickname.find params[:id]
    if @nickname.update_attributes params[:nickname]
      redirect_to admin_nicknames_path, :notice => t('messages.nicknames.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end

  def search
   add_breadcrumb :index
   add_breadcrumb params[:nickname][:name]
    if params[:nickname][:name].blank?
      redirect_to :admin_nicknames, :alert => t("messages.nicknames.search_error")
      return
    else
      @nicknames = Nickname.search_name(params[:nickname][:name]).page(params[:page]).per(Setting.page_size)
    end
   render :index
  end

  def destroy
    @nickname = Nickname.find params[:id]
    if @nickname.destroy
      redirect_to admin_nicknames_path , notice: t('messages.nicknames.success')
    else
      redirect_to admin_nicknames_path , alert: t('messages.nicknames.error')
    end
  end
end