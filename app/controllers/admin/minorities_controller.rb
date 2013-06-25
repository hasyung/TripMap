class Admin::MinoritiesController < Admin::ApplicationController
  before_filter :find_parent_model
  
  def index
    @minorities = @parent.minorities.page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = @parent.minorities.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = @parent.minorities.new params[:minority]
    if @model.save
      redirect_to @path, notice: t('messages.minorities.success')
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
      redirect_to @path, notice: t('messages.minorities.success')
    else
      render :edit
    end
  end

  def destroy
    @minority = Minority.find params[:id]
    if @minority.destroy
      redirect_to @path, notice: t('messages.minorities.success')
    else
      redirect_to @path, alert: t('messages.minorities.error')
    end
  end
  
  def show
    add_breadcrumb :show
    @model = Minority.find params[:id]
    @slides = @model.minority_slides.order_asc
    @feels = @model.minority_feels.order_asc
  end
  
  private
  def find_parent_model
    if !params[:special_id].blank?
      @parent = Special.find params[:special_id]
      @path = admin_special_minorities_path(params[:special_id])
    elsif !params[:fight_id].blank?
      @parent = Fight.find params[:fight_id]
      @path = admin_fight_minorities_path(params[:fight_id])
    end
  end

end
