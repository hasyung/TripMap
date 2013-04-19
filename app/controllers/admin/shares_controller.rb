class Admin::SharesController < Admin::ApplicationController

  def index
    @shares = Share.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @share = Share.new
    add_breadcrumb :new
  end

  def create
    @share = Share.new params[:share]
    if @share.save
      redirect_to admin_shares_path, :notice => t('messages.shares.success')
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @share = Share.find params[:id]
    add_breadcrumb :edit
  end

  def update
    @share = Share.find params[:id]
    if @share.update_attributes params[:share]
      redirect_to admin_shares_path, :notice => t('messages.shares.success')
    else
      render :edit
    end
    add_breadcrumb :edit
  end

  def select
    @map = Map.find params[:map][:name]
    add_breadcrumb :index
    add_breadcrumb @map.name
    @shares = @map.shares.page(params[:page]).per(Setting.page_size).created_desc
    render :index
  end

  def show
    @share = Share.find params[:id]
    add_breadcrumb @share.title
  end

  def publish
    @share = Share.find params[:id]
    @share.state = params[:status].to_s.to_sym
    if @share.save
      if @share.publish?
        redirect_to admin_shares_path, :notice => t("messages.shares.publish")
      else
        redirect_to admin_shares_path, :notice => t("messages.shares.draft")
      end
    else
      redirect_to admin_shares_path, :alert => t("messages.shares.error")
    end
  end

  def destroy
    @share = Share.find params[:id]
    if @share.destroy
      redirect_to admin_shares_path , notice: t('messages.shares.success')
    else
      redirect_to admin_shares_path , alert: t('messages.shares.error')
    end
  end

end