#encoding: utf-8

class  Api::V1x::MapsController < Api::V1x::ApplicationController

  def index
    fields = ['device_id']
    ( render :json => set_msg("errors.api.maps.device_id"); return ) if has_nil_value_in fields
    d = Device.find_by_device_id params[:device_id]
    serials = d.blank? ? [] : d.map_serial_numbers.map(&:code)

    result = []
    Map.all.each do |map|
      result << {
        :id => map.id, :name => map.name, :slug => map.map_slug.slug,
        :version => map.version, :cover => map.map_cover.file.url,
        :serial => serials
      }
    end
    render :json => result

  end

end