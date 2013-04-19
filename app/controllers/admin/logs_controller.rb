class Admin::LogsController < Admin::ApplicationController

  def index
    @logs = Log.page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def select
    @map = Map.find params[:map][:name]
    add_breadcrumb :index
    add_breadcrumb @map.name
    @logs = @map.logs.page(params[:page]).per(Setting.page_size).created_desc
    render :index
  end

end