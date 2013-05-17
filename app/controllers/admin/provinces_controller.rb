class Admin::ProvincesController < Admin::ApplicationController

  def index
    @provinces = Province.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @province = Province.new
    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @province = Province.new params[:province]
    if @province.save
      redirect_to admin_provinces_path, notice: t('messages.provinces.success')
    else
      render :new
    end
  end

  def edit
    @province = Province.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @province = Province.find params[:id]
    if @province.update_attributes params[:province]
      redirect_to admin_provinces_path , notice: t('messages.provinces.success')
    else
      render :edit
    end
  end

  def destroy
    @province = Province.find params[:id]
    if @province.destroy
      redirect_to admin_provinces_path , notice: t('messages.provinces.success')
    else
      redirect_to admin_provinces_path , alert: t('messages.provinces.error')
    end
  end

end