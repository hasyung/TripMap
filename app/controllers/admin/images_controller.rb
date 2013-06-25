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
    if params.has_key?(:map_id)
      @model = Map.find params[:map_id]
      @image = @model.map_slides.new params[:image]
      @path  = edit_admin_map_path(@model.id)
    elsif params.has_key?(:place_id)
      @model = Place.find params[:place_id]
      @image = @model.place_slides.new params[:image]
      @path  = edit_admin_place_path(@model.id)
    elsif params.has_key?(:scenic_id)
      @model = Scenic.find params[:scenic_id]
      @image = @model.scenic_slides.new params[:image]
      @path  = edit_admin_scenic_path(@model.id)
    elsif params.has_key?(:merchant_id)
      @model = Merchant.find params[:merchant_id]
      @image = @model.merchant_slides.new params[:image]
      @path  = edit_admin_merchant_path(@model.id)
    elsif params.has_key?(:minority_feel_id)
      @model = MinorityFeel.find(params[:minority_feel_id], include: [:minority])
      @image = @model.minority_feel_slides.new params[:image]
      parent = @model.minority.minorityable_type.constantize.find(@model.minority.minorityable_id)
      if parent.class.to_s == "Special"
        @path = edit_admin_special_minority_feel_path(parent.id, @model.minority.id, @model.id)
      elsif parent.class.to_s == "Fight"
        @path = edit_admin_fight_minority_feel_path(parent.id, @model.minority.id, @model.id)
      end
    elsif params.has_key?(:first_known_id)
      @model = FirstKnown.find params[:first_known_id]
      @image = @model.first_known_slides.new params[:image]
      @path  = edit_admin_first_known_path(@model.id)
    elsif params.has_key?(:recommend_id)
      @model = Recommend.find params[:recommend_id]
      @image = @model.recommend_slides.new params[:image]
      @path  = edit_admin_recommend_path(@model.id)
    end
  end

end