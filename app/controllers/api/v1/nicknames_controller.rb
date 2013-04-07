class Api::V1::NicknamesController < Api::V1::ApplicationController

  def show
    result = {}
    (render :json => result; return) if params[:device_id].nil?

    device_id = ActivateMap.find{|a| a.device_id == params[:device_id]}
    is_present = device_id.present? and device_id.nickname.present?
    result = {id: device_id.nickname.id, nickname: device_id.nickname.name} if is_present

    render :json => result
  end

  def create
    result = {result: false}

    nick_name = params[:nickname]
    is_invalid_params = params[:device_id].nil? or nickname.nil?
    (render :json => result; return) if is_invalid_params

    device_id = ActivateMap.find{ |a| a.device_id == params[:device_id] }

    if device_id.present? and Nickname.find{ |o| o.name == nick_name }.blank?
      if device_id.nickname.blank?
        device_id.build_nickname nickname: nick_name
      else
        device_id.nickname.name = nick_name
      end
      result = {result: true} if device_id.save
    end

    render :json => result
  end

end