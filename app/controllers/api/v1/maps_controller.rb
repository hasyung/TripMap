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

    is_invalid_params = params[:device_id].nil? or params[:map_id].nil? or params[:serial].nil?
    ( render :json => result; return ) if is_invalid_params

    ( render :json => result; return ) if !validate_client_state

    mid = params[:map_id].to_i
    map = Map.find mid
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

    (render :json => result; return) if params[:id].nil?

    map = Map.find{ |o| o.id = params[:id] }
    result = { version: map.version } if not map.nil?

    render :json => result
  end

  private

  def validate_client_state
    ip = request.remote_ip
    return false if ip.blank?
    past_ip = IpAddress.find{|i| i.ip == ip}
    if past_ip.blank?
      IpAddress.create ip: ip
      return true
    else
      if Time.now() - past_ip.created_at > 3600
        past_ip.destroy
        IpAddress.create ip: ip
        return true
      elsif past_ip.counter > 100
        return false
      else
        past_ip.counter += 1
        past_ip.save
        return true
      end
    end
  end
end