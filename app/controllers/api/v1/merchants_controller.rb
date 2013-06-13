class Api::V1::MerchantsController < Api::V1::ApplicationController

  def index
    result = []
    Merchant.all.each do |m|
      result << { :id => m.id, :name => m.name, :slug => m.merchant_slug.slug }
    end
    render :json => result
  end

  def show
    result = {}
    merchant = Merchant.find params[:id]
    if merchant.present?
      slides = []
      merchant.merchant_slides.order_asc.each{ |o| slides << { image: o.file.url} } if merchant.merchant_slides.present?
      result = {
        title: merchant.title,
        tag: merchant.tag,
        phone: merchant.phone,
        address: merchant.address,
        shop_hour: merchant.shop_hour,
        expence: merchant.expence,
        description: merchant.description,
        special: merchant.special,
        slides: slides
      }
    end

    render :json => result
  end

end