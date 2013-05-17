class Admin::CountiesController < Admin::ApplicationController

  def index
    @counties = County.includes(:city).page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def new
    @county = County.new
    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @county = County.new params[:county]
    if @county.save
      redirect_to admin_counties_path, notice: t('messages.counties.success')
    else
      render :new
    end
  end

  def edit
    @county = County.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @county = County.find params[:id]
    if @county.update_attributes params[:county]
      redirect_to admin_counties_path , notice: t('messages.counties.success')
    else
      render :edit
    end
  end

  def destroy
    @county = County.find params[:id]
    if @county.destroy
      redirect_to admin_counties_path , notice: t('messages.counties.success')
    else
      redirect_to admin_counties_path , alert: t('messages.counties.error')
    end
  end

end