class Admin::ScenicsController < Admin::ApplicationController

  def index
    @scenics = Scenic.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = Scenic.new

    add_breadcrumb :new
  end

  def create
    @model = Scenic.new params[:scenic]
    if @model.save
      set_slug(params[:scenic][:slug], @model.scenic_slugs)
      redirect_to admin_scenics_path, notice: t('messages.scenics.success')
    else
      render :new
    end
  end

  def edit
    @model = Scenic.find params[:id]
    @model.slug = Keyword.get_slug(@model.scenic_slugs)
    @images = @model.scenic_slides.order_asc
    add_breadcrumb :edit
  end

  def update
    @model = Scenic.find params[:id]
    set_slug(params[:scenic][:slug], @model.scenic_slugs)
    if @model.update_attributes params[:scenic]
      redirect_to admin_scenics_path, notice: t('messages.scenics.success')
    else
      render :edit
    end
  end

  def destroy
    @scenic = Scenic.find params[:id]
    if @scenic.destroy
      redirect_to admin_scenics_path, notice: t('messages.scenics.success')
    else
      redirect_to admin_scenics_path, alert: t('messages.scenics.error')
    end
  end

end