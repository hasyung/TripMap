class Admin::FightsController < Admin::ApplicationController

  def index
    @fights = Fight.page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @fight = Fight.new

    add_breadcrumb :new
  end

  def create
    @fight = Fight.new params[:fight]
    if params[:type] == "true"
      @city = City.find params[:fight][:city].to_i if params[:fight][:city].to_i != 0
      render :new
    else
      if @fight.save
        set_slug(params[:fight][:slug], @fight.fight_slugs)
        redirect_to admin_fights_path, notice: t('messages.fights.success')
      else 
        render :new
      end
    end
    
  end

  def edit
    add_breadcrumb :edit
    @fight = Fight.find params[:id]
    @fight.slug = Keyword.get_slug(@fight.map_slugs)
  end

  def update
    add_breadcrumb :edit
    @fight = Fight.find params[:id]
    if params[:type] == "true"
      @city = City.find params[:fight][:city].to_i if params[:fight][:city].to_i != 0
      render :edit
    else
      set_slug(params[:fight][:slug], @fight.fight_slugs)
      if @fight.update_attributes params[:fight]
        redirect_to admin_fights_path, notice: t('messages.fights.success')
      else
        render :edit
      end
    end
    
  end

  def destroy
    @fight = Special.find params[:id]
    if @fight.destroy
      redirect_to admin_fights_path, notice: t('messages.fights.success')
    else
      redirect_to admin_fights_path, alert: t('messages.fights.error')
    end
  end

end