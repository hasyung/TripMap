class Admin::ImagesController < Admin::ApplicationController
  before_filter :find_parent_model

  def new
    @image = Image.new
    add_breadcrumb :new
  end

  def create
    if @image.save
      redirect_to @path, :notice => t('messages.slides.success', :model => @model.class.model_name.human)
    else
      render :new
    end
    add_breadcrumb :new
  end

  def edit
    @image = Image.find params[:id]
    add_breadcrumb :edit
  end

  def update
    @image = Image.find params[:id]
    if @image.update_attributes params[:image]
      redirect_to @path, :notice => t('messages.slides.success', :model => @model.class.model_name.human)
    else
      render :edit
    end
    add_breadcrumb :edit
  end

  def destroy
    @image = Image.find params[:id]
    if @image.destroy
      redirect_to @path, :notice => t('messages.slides.success', :model => @model.class.model_name.human)
    else
      redirect_to @path, :alert => t('messages.slides.error', :model => @model.class.model_name.human)
    end
  end

  private
  def find_parent_model
    if params[:map_id].present?
      @model = Map.find params[:map_id]
      @image = @model.map_slides.new params[:image]
      @path = edit_admin_map_path(@model.id)
    elsif params[:place_id].present?
      @model = Place.find params[:place_id]
      @image = @model.place_slides.new params[:image]
      @path = edit_admin_place_path(@model.id)
    elsif params[:scenic_id].present?
      @model = Scenic.find params[:scenic_id]
      @image = @model.scenic_slides.new params[:image]
      @path = edit_admin_scenic_path(@model.id)
    elsif params[:merchant_id].present?
      @model = Merchant.find params[:merchant_id]
      @image = @model.merchant_slides.new params[:image]
      @path = edit_admin_merchant_path(@model.id)
    elsif params[:minority_feel_id].present?
      @model = MinorityFeel.find(params[:minority_feel_id], include: [:minority])
      @image = @model.minority_feel_slides.new params[:image]
      @path = edit_admin_special_minority_feel_path(@model.minority.special.id, @model.minority.id, @model.id)
    end
  end

end