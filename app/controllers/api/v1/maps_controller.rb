class Api::V1::MapsController < Api::V1::ApplicationController
    
  def index
    result = []
  	Map.all.each do |map|			
  	  result << {  :id => map.id,
                   :name => map.name,
                   :slug => map.slug,
                   :version => map.version
                }
  	end
  	render :json => result
  end

  def show
    map = Map.find params[:map_id].to_i
    serial = MapSerialNumber.find{|num| num.code == params[:serial] }
    result= {}
    if serial.present? && serial.map_id == params[:map_id].to_i && serial.count > 0
      serial.count -= 1
      serial.save
      active_entity =  { :device_id => params[:device_id], :map_id => map.id, :map_serial_number_id => serial.id }
      ActivateMap.create active_entity

      if !Rails.cache.exist?("map_#{map.id}")
        Rails.cache.write("map_#{map.id}", map.get_map_values)
      end
      result = Rails.cache.read("map_#{map.id}")
    end
    render :json => result
  end

  def version
    map = Map.find params[:id]
    result = {version: map.version}
    render :json => result
  end

end
