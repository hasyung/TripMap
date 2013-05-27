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
    ret = { result: false }

    fields = [ 'device_id', 'serial' ]
    ( render :json => ret.merge(set_msg("errors.api.invalid_params")); return ) if has_nil_value_in fields

    uuid = params[:device_id]
    device = Device.find_by_device_id uuid
    device = Device.create device_id: uuid if device.blank?
    ( render :json => ret.merge(set_msg("errors.api.devices.device_create_error")); return ) if device.blank?

    serial = MapSerialNumber.where(:code => params[:serial]).first
    (render :json => ret.merge(set_msg("errors.api.devices.serial_error")); return) if serial.blank?
    (render :json => ret.merge(set_msg("errors.api.devices.ser_count_used_exp")); return) if serial.devices.count >= Setting.serial_devices_size.to_i
    (render :json => ret.merge(set_msg("errors.api.devices.map_registered")); return) if get_maps_from_serials(device.map_serial_numbers).include?(serial.map_id)

    device.map_serial_numbers << serial
    if serial.activate_cd == 0
      serial.activate_cd = 1
      serial.save
    end

    ret[:result] = true
    render :json => ret.merge(set_msg("tips.api.success"))
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