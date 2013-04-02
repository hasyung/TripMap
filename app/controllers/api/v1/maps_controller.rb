class Api::V1::MapsController < Api::V1::ApplicationController
  def index
    result = []
    Map.all.each do |map|
      result << { :id => map.id, :name => map.name, :slug => map.slug, :version => map.version }
    end

    render :json => result
  end

  def show
    result= {}

    mid = params[:map_id].to_i
    map = Map.find{ |o| o.id == mid }
    ( render :json => result; return ) if map.nil?                # Check map

    serial = MapSerialNumber.find{|o| o.code == params[:serial] }
    ( render :json => result; return ) if serial.nil?             # Check user's serial number
    ( render :json => result; return ) if serial.map_id != mid    # Check user's serial number match for map

    device_id = params[:device_id]
    query_sql = "device_id=? AND map_id=? AND map_serial_number_id=?"
    is_new_device = ActivateMap.where(query_sql, device_id, mid, serial.id).empty?

    if is_new_device
      ( render :json => result; return ) if serial.count.zero?    # Check serial's count exhaust

      serial.count -= 1; serial.save
      active_entity =  { :device_id => device_id, :map_id => mid, :map_serial_number_id => serial.id }
      ActivateMap.create active_entity
    end

    cache_key = "map_#{map.id}"
    Rails.cache.write(cache_key, map.get_map_values) if !Rails.cache.exist?(cache_key)

    render :json => Rails.cache.read(cache_key)
  end

  def version
    result = {}

    map = Map.find{ |o| o.id = params[:id] }
    result = { version: map.version } if not map.nil?

    render :json => result
  end

end