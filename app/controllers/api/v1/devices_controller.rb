# encoding : utf-8

class Api::V1::DevicesController < Api::V1::ApplicationController

  def index
    maps = []
    ( render :json => {maps: maps}; return ) if params[:device_id].blank?

    device = Device.find_by_device_id params[:device_id]
    ( render :json => {maps: maps}; return ) if device.blank?
    serials = device.map_serial_numbers
    maps = get_maps_from_serials(serials) if serials.count > 0
    render :json => {maps: maps}
  end

  def validate
    ( render :json => {result: "参数错误,请核对！"}; return ) if params[:device_id].blank? || params[:serial].blank?

    device = Device.find_by_device_id params[:device_id]
    device = Device.create device_id: params[:device_id] if device.blank?
    ( render :json => {result: "参数错误,请核对！"}; return ) if device.blank?

    serial = MapSerialNumber.where("code = '#{params[:serial]}'").first
    (render :json => {result: "序列号错误,请核对！"}; return) if serial.blank?
    (render :json => {result: "序列号使用次数超过限制！"}; return) if serial.devices.count >= Setting.serial_devices_size.to_i
    (render :json => {result: "此地图已激活,无需重复激活！"}; return) if get_maps_from_serials(device.map_serial_numbers).include?(serial.map_id)

    device.map_serial_numbers << serial
    if serial.activate_cd == 0
      serial.activate_cd = 1
      serial.save
    end
    render :json => {result: "成功！"}
  end

  private
  def get_maps_from_serials serials
    maps = []
    serials.each do |serial|
      maps << serial.map_id
    end
    maps.uniq
  end
end