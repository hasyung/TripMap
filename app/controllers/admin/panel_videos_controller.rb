class Admin::PanelVideosController < Admin::ApplicationController

  def index
    @models = PanelVideo.includes(:map).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = PanelVideo.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = PanelVideo.new params[:panel_video]
    if @model.save
      set_slug(params[:panel_video][:slug], @model.panel_video_slugs)
      redirect_to admin_panel_videos_path, notice: t('messages.panel_videos.success')
    else
      render :new
    end
  end

  def edit
    @model = PanelVideo.find params[:id]
    @model.slug = Keyword.get_slug(@model.panel_video_slugs)
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = PanelVideo.find params[:id]
    set_slug(params[:panel_video][:slug], @model.panel_video_slugs)
    if @model.update_attributes params[:panel_video]
      redirect_to admin_panel_videos_path, notice: t('messages.panel_videos.success')
    else
      render :edit
    end
  end

  def destroy
    @model = PanelVideo.find params[:id]
    if @model.destroy
      redirect_to admin_panel_videos_path, notice: t('messages.panel_videos.success')
    else
      redirect_to admin_panel_videos_path, alert: t('messages.panel_videos.error')
    end
  end

end