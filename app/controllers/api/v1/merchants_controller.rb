class Api::V1::MerchantsController < Api::V1::ApplicationController

  def index
    result = []
    Merchant.all.each do |m|
      result << { :id => m.id, :name => m.name, :slug => m.slug }
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
                description: merchant.description,
                slides: slides
              }
    end

    render :json => result
  end

end