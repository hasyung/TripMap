class Admin::ScenicsController < Admin::ApplicationController
  def index
    @scenics = Scenic.page(params[:page]).per(Setting.page_size).created_desc
  end

  def new
    @scenic = Scenic.new
  end

  def create
    @scenic = Scenic.new params[:scenic]
    if @scenic.save
      redirect_to admin_scenics_path, notice: t('messages.scenics.success')
    else
      render :new
    end
  end

  def edit
    @scenic = Scenic.find params[:id]
  end

  def update
    @scenic = Scenic.find params[:id]
    if @scenic.update_attributes params[:scenic]
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
      redirect_to admin_scenics_path, notice: t('messages.scenics.error')
    end
  end
end
