class Admin::RecommendsController < Admin::ApplicationController

  def index
    @recommends = Recommend.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = Recommend.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = Recommend.new params[:recommend]
    if @model.save
      redirect_to admin_recommends_path, notice: t('messages.recommends.success')
    else 
      render :new
    end
  end

  def edit
    add_breadcrumb :edit
    @model = Recommend.find params[:id]
    @images = @model.recommend_slides.order_asc
  end

  def update
    add_breadcrumb :edit
    @model = Recommend.find params[:id]
    if @model.update_attributes params[:recommend]
      redirect_to admin_recommends_path, notice: t('messages.recommends.success')
    else
      render :edit
    end
  end

  def destroy
    recommend = Recommend.find params[:id]
    if recommend.destroy
      redirect_to admin_recommends_path, notice: t('messages.recommends.success')
    else
      redirect_to admin_recommends_path, alert: t('messages.recommends.error')
    end
  end

end