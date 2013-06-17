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
    ret = { result: "false" }

    fields = [ 'device_id', 'serial', 'map_id' ]
    ( render :json => ret.merge(set_msg("errors.api.invalid_params")); return ) if has_nil_value_in fields

    uuid = params[:device_id]
    device = Device.find_by_device_id uuid
    device = Device.create device_id: uuid if device.blank?
    ( render :json => ret.merge(set_msg("errors.api.devices.device_create_error")); return ) if device.blank?

    has_serial = MapSerialNumber.where(:code => params[:serial]).first
    ( render :json => ret.merge(set_msg("errors.api.devices.serial_error")); return ) if has_serial.blank?

    match_map_serial = MapSerialNumber.where(:code => params[:serial], :map_id => params[:map_id]).first
    (render :json => ret.merge(set_msg("errors.api.devices.serial_not_match_map")); return) if match_map_serial.blank?
    (render :json => ret.merge(set_msg("errors.api.devices.ser_count_used_exp")); return) if match_map_serial.devices.count >= Setting.serial_devices_size.to_i
    (render :json => ret.merge(set_msg("errors.api.devices.map_registered")); return) if get_maps_from_serials(device.map_serial_numbers).include?(match_map_serial.map_id)

    device.map_serial_numbers << match_map_serial
    if match_map_serial.activate_cd == 0
      match_map_serial.activate_cd = 1
      match_map_serial.save
    end

    ret[:result] = "true"
    render :json => ret.merge(set_msg("tips.api.success"))
  end

  def unbind_device
    ret = { result: "false" }
    fields = [ 'device_id' ]
    ( render :json => ret.merge(set_msg("errors.api.maps.device_id")); return ) if has_nil_value_in fields

    d = Device.find_by_device_id params[:device_id]
    ( render :json => ret.merge(set_msg("errors.api.maps.device_id")); return ) if d.nil?

    d.destroy
    ret[:result] = "true"
    render :json => ret.merge(set_msg("tips.api.success"))
  end

  private
  def get_maps_from_serials serials
    maps = []
    serials.each{|serial| maps << serial.map_id }
    maps.uniq
  end

end