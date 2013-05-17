class Admin::MerchantsController < Admin::ApplicationController

  def index
    @merchants = Merchant.includes(:county).page(params[:page]).per(Setting.page_size).created_desc

    add_breadcrumb :index
  end

  def new
    @model = Merchant.new
    add_breadcrumb :new
  end

  def create
    add_breadcrumb :new
    @model = Merchant.new params[:merchant]
    if params[:type] == "true"
      @city = City.find params[:merchant][:city].to_i if params[:merchant][:city].to_i != 0
      render :new
    else
      if @model.save
        redirect_to admin_merchants_path, notice: t('messages.merchants.success')
      else
        render :new
      end
    end
  end

  def edit
    @model = Merchant.find params[:id]
    @images = @model.merchant_slides.order_asc
    add_breadcrumb :edit
  end

  def update
    add_breadcrumb :edit
    @model = Merchant.find params[:id]
    if params[:type] == "true"
      @city = City.find params[:merchant][:city].to_i if params[:merchant][:city].to_i != 0
      @images = Merchant.find(params[:id]).merchant_slides.order_asc
      render :edit
      @model = Merchant.new params[:merchant]
    else
      if @model.update_attributes params[:merchant]
        redirect_to admin_merchants_path, notice: t('messages.merchants.success')
      else
        render :edit
      end
    end
  end

  def destroy
    @merchant = Merchant.find params[:id]
    if @merchant.destroy
      redirect_to admin_merchants_path, notice: t('messages.merchants.success')
    else
      redirect_to admin_merchants_path, alert: t('messages.merchants.error')
    end
  end

end
