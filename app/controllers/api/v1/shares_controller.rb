class Api::V1::SharesController < Api::V1::ApplicationController

  def current
    result = []
    @map = Map.find params[:map_id].to_i
    (render :json => result; return) if @map.blank?
    size = params[:page_size].to_i
    index = params[:page_index].to_i
    first = (index-1)*size
    last = index*size - 1
    @shares = @map.shares.publish
    if !@shares.blank?
      if (@shares.count - 1) > first
        if (@shares.count - 1) >= last
          shares = @shares.values_at(first..last)
         else
          shares = @shares.values_at(first..(@shares.count - 1))
         end 
        shares.each do |share|
          result << get_share_value(share)
        end
      elsif (@shares.count - 1) == first
        share = @shares[first]
        result << get_share_value(share)
      end
    end
    render :json => result
  end

  def nearby
    result = []
    @map = Map.find params[:map_id].to_i
    (render :json => result; return) if @map.blank?
    @shares = Share.publish.reject {|lambda| lambda.map_id == params[:map_id].to_i}
    size = params[:page_size].to_i
    index = params[:page_index].to_i
    first = (index-1)*size
    last = index*size - 1
    if !@shares.blank?
      if (@shares.count - 1) > first
        if (@shares.count - 1) >= last
          shares = @shares.values_at(first..last)
         else
          shares = @shares.values_at(first..(@shares.count - 1))
         end 
        shares.each do |share|
          result << get_share_value(share)
          end
      elsif (@shares.count - 1) == first
        share = @shares[first]
        result << get_share_value(share)
      end
    end
    render :json => result
  end

  def create
    result = {result: false}
    map = Map.find params[:map_id].to_i
    if map.present?
      nickname = Nickname.find params[:nickname_id].to_i
      if nickname.present?
        @share = map.shares.new
        @share.title = params[:title]
        @share.nickname_id = nickname.id
        @share.device_id = params[:device_id]
        @share.build_share_image file: params[:image]
        @share.build_share_text body: params[:text]
        if @share.save
          result = {result: true}
        end
      end
    end
    render :json => result
  end

  private
  def get_share_value(share)
    r = {id: share.id,
         title: share.title,
         nickname: Nickname.find(share.nickname_id).name,
         device_id: share.device_id,
         image: share.share_image.file.url,
         cover: share.share_image.file.thumbnail.url,
         text: share.share_text.body
         }
  end
end