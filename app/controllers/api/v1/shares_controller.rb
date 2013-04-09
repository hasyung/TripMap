# encoding:utf-8

class Api::V1::SharesController < Api::V1::ApplicationController

  def current
    result = []
     (render :json => result; return) if params[:map_id].blank? || params[:page_size].blank? || params[:page_index].blank?
    @map = Map.find_by_id params[:map_id].to_i
    (render :json => result; return) if @map.blank?
    size = params[:page_size].to_i
    index = params[:page_index].to_i
    first = (index-1)*size
    last = index*size - 1
    @shares = @map.shares.publish.created_desc
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
    (render :json => result; return) if params[:map_id].blank? || params[:page_size].blank? || params[:page_index].blank?
    @map = Map.find_by_id params[:map_id].to_i
    (render :json => result; return) if @map.blank?
    @shares = Share.publish.reject{|lambda| lambda.map_id == params[:map_id].to_i}.created_desc
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
     (render :json => result; return) if params[:map_id].blank? || params[:device_id].blank? || params[:title].blank? ||
                                         params[:image].blank? ||params[:text].blank?
    map = Map.find_by_id params[:map_id].to_i
    device_id = ActivateMap.find{|a| a.device_id == params[:device_id]}
    if map.present?
      @share = map.shares.new
      @share.title = params[:title]
      @share.nickname_id = (device_id.present? && device_id.nickname.present? ) ? device_id.nickname.id : 0  
      @share.build_share_image file: params[:image]
      @share.build_share_text body: params[:text]
      if @share.save
        result = {result: true}
      end
    end
    render :json => result
  end

  private
  def get_share_value(share)
    r = {id: share.id,
         title: share.title,
         nickname: Nickname.find(share.nickname_id).present?? Nickname.find(share.nickname_id).name : "游客",
         image: share.share_image.file.url,
         cover: share.share_image.file.thumbnail.url,
         text: share.share_text.body
         }
  end
end