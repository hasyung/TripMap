class Admin::FirstKnownsController < Admin::ApplicationController

    def index
    @models = FirstKnown.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = FirstKnown.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = FirstKnown.new params[:first_known]
    if @model.save
      redirect_to admin_first_knowns_path, notice: t('messages.commons.success')
    else
      render :new
    end
  end

  def edit
    @model = FirstKnown.find params[:id]
    @images = @model.first_known_slides.order_asc
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = FirstKnown.find params[:id]
    if @model.update_attributes params[:first_known]
      redirect_to admin_first_knowns_path, notice: t('messages.commons.success')
    else
      render :edit
    end
  end

  def destroy
    @model = FirstKnown.find params[:id]
    if @model.destroy
      redirect_to admin_first_knowns_path, notice: t('messages.commons.success')
    else
      redirect_to admin_first_knowns_path, alert: t('messages.commons.error')
    end
  end

end