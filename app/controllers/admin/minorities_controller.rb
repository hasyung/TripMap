class Admin::MinoritiesController < Admin::ApplicationController

  def index
    @minorities = Minority.includes(:special).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    special = Special.find params[:special_id]
    @model = special.minorities.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    special = Special.find params[:special_id]
    @model = special.minorities.new params[:minority]
    if @model.save
      redirect_to admin_special_minorities_path(@model.special_id), notice: t('messages.minorities.success')
    else
      render :new
    end
  end

  def edit
    @model = Minority.find params[:id]
    @images = @model.minority_slides.order_asc
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = Minority.find params[:id]
    if @model.update_attributes params[:minority]
      redirect_to admin_special_minorities_path(@model.special_id), notice: t('messages.minorities.success')
    else
      render :edit
    end
  end

  def destroy
    @minority = Minority.find params[:id]
    if @minority.destroy
      redirect_to admin_special_minorities_path(@minority.special_id), notice: t('messages.minorities.success')
    else
      redirect_to admin_special_minorities_path(@minority.special_id), alert: t('messages.minorities.error')
    end
  end
  
  def show
    add_breadcrumb :show
    @model = Minority.find params[:id]
    @slides = @model.minority_slides.order_asc
    @feels = @model.minority_feels.order_asc
  end

end
