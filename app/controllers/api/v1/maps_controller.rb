class Api::V1::MapsController < Api::V1::ApplicationController

  def index
    Rails.cache.write("maps", Map.get_all_maps) if !Rails.cache.exist?("maps")

    render :json => Rails.cache.read(("maps")
  end

  def show
    result= {}
    ( render :json => result; return ) if params[:map_id].nil? || !validate_client_state
    mid = params[:map_id].to_i
    if Rails.cache.exist?("maps")
      map = Rails.cache.read(("maps").find{|a| a[:id] == mid }
    else
      map = Map.find_by_id mid
    end
    ( render :json => result; return ) if map.nil?                # Check map
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

  def validate
    result= {maps: []}
    ( render :json => result; return ) if params[:device_id].blank?

    activate_map = ActivateMap.find{ |o| o.device_id == params[:device_id] }
    ( render :json => result; return ) if activate_map.blank?

    result = {maps: get_activate_maps(activate_map)}
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

  def get_activate_maps activate_map
    maps = []
    activate_map.accounts.each{|a| maps << a.map_serial_number.map_id if a.map_serial_number.present?}
    maps = maps.uniq
  end
end