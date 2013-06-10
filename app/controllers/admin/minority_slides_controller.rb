class Admin::MinoritySlidesController < Admin::ApplicationController

  def new
    minority = Minority.find params[:minority_id]
    @model = minority.minority_slides.new

    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    minority = Minority.find params[:minority_id]
    @model = minority.minority_slides.new params[:minority_slide]
    if @model.save
      redirect_to admin_special_minority_path(params[:special_id], params[:minority_id]), notice: t('messages.minority_slides.success')
    else
      render :new
    end
  end

  def edit
    @model = MinoritySlide.find params[:id]
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = MinoritySlide.find params[:id]
    if @model.update_attributes params[:minority_slide]
      redirect_to admin_special_minority_path(params[:special_id], params[:minority_id]), notice: t('messages.minority_slides.success')
    else
      render :edit
    end
  end

  def destroy
    @minority_slide = MinoritySlide.find params[:id]
    if @minority_slide.destroy
      redirect_to admin_special_minority_path(params[:special_id], params[:minority_id]), notice: t('messages.minority_slides.success')
    else
      redirect_to admin_special_minority_path(params[:special_id], params[:minority_id]), alert: t('messages.minority_slides.error')
    end
  end

end
