# encoding:utf-8

class Api::V1::NicknamesController < Api::V1::ApplicationController

  def show
    result = {nickname: "游客"}
    (render :json => result; return) if params[:device_id].nil?
    
    device_id = ActivateMap.find{|a| a.device_id == params[:device_id]}
    is_present = device_id.present? and device_id.nickname.present?
    result = {nickname: device_id.nickname.name} if is_present

    render :json => result
  end

  def create
    result = {result: false}

    nickname, device_id = params[:nickname], params[:device_id]

    is_invalid_params = device_id.nil? or nickname.nil?
    (render :json => result; return) if is_invalid_params

    activate_map = ActivateMap.find{ |o| o.device_id == device_id }

    if activate_map.present? and Nickname.find{ |o| o.name == nickname }.blank?
      if activate_map.nickname.blank?
        activate_map.build_nickname name: nickname
      else
        activate_map.nickname.name = nickname
      end
      result = {result: true} if activate_map.nickname.save
    end

    render :json => result
  end

end