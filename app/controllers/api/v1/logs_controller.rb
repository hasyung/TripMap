class Api::V1::LogsController < Api::V1::ApplicationController

  def create
    ret = {result: false}

    is_invalid_params =  params[:device_id].nil? or params[:map_id].nil? or
                         params[:device_type].nil? or params[:slug].nil? or
                         params[:message].nil? or params[:info].nil?
    (render :json => ret; return) if is_invalid_params

    activate_map = ActivateMap.find {|a| a.device_id == params[:device_id]}
    activate_map = ActivateMap.create(device_id: params[:device_id]) if activate_map.blank?
    activate_map.logs.new map_id:         params[:map_id].to_i,
                          device_type_cd: params[:device_type].to_i,
                          slug:           params[:slug].downcase,
                          message_cd:     params[:message].to_i,
                          info:        params[:info]

    ret = {result: true} if activate_map.save

    render :json => ret
  end

end