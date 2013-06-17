#encoding: utf-8

class  Api::V1x::MapsController < Api::V1x::ApplicationController

  def index
    fields = ['device_id']
    ( render :json => set_msg("errors.api.maps.device_id"); return ) if has_nil_value_in fields

    d = Device.find_by_device_id params[:device_id]
    serials = d.blank? ? [] : d.map_serial_numbers.map(&:code)
    ar_map_serial = []

    unless serials.empty?
      d.map_serial_numbers.each{|e| ar_map_serial << { map_id: e.map.id, code: e.code }}
    end
    result = []

    Map.all.each do |map|
      serials_tmp = []
      ar_map_serial.each{|e| serials_tmp << e[:code] if e[:map_id] == map.id }

      result << {
        :id => map.id, :name => map.name, :slug => map.map_slug.slug,
        :version => map.version.to_s, :cover => map.map_cover.file.url,
        :serial => serials_tmp
      }
    end

    render :json => result
  end

end