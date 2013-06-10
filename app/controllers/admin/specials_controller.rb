class Admin::SpecialsController < Admin::ApplicationController
  def index
    @specials = Special.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @special = Special.new

    add_breadcrumb :new
  end

  def create
    @special = Special.new params[:special]
    if @special.save
      redirect_to admin_specials_path, notice: t('messages.specials.success')
    else 
      render :new
    end
  end

  def edit
    add_breadcrumb :edit
    @special = Special.find params[:id]
  end

  def update
    add_breadcrumb :edit
    @special = Special.find params[:id]
    if @special.update_attributes params[:special]
      redirect_to admin_specials_path, notice: t('messages.specials.success')
    else
      render :edit
    end
  end

  def destroy
    @special = Special.find params[:id]
    if @special.destroy
      redirect_to admin_specials_path, notice: t('messages.specials.success')
    else
      redirect_to admin_specials_path, alert: t('messages.specials.error')
    end
  end

end