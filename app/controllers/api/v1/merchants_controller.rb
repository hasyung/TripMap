class Api::V1::MerchantsController < Api::V1::ApplicationController

  def index
    result = []
    Merchant.all.each do |m|
      result << {
        :id => m.id, :name => m.name,
        :slug => m.merchant_slug.slug,
        :phone => m.phone, :type => m.type_cd,
        :image => get_url(m.merchant_image),
        :horizontal_image => get_url(m.merchant_horizontal_image) 
      }
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
        title:       merchant.title,
        tag:         merchant.tag,
        address:     merchant.address,
        shop_hour:   merchant.shop_hour,
        expence:     merchant.expence,
        description: merchant.description,
        special:     merchant.special,
        slides:      slides
      }
    end

    render :json => result
  end

end