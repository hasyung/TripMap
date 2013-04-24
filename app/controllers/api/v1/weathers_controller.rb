require 'weather/api'

class Api::V1::WeathersController < Api::V1::ApplicationController

  DAY_SECONDS = 24 * 60 * 60

  def index
    weather = {}

    mid = params[:map_id]
    ( render :json => weather; return ) if mid.nil?

    map = Map.find_by_id mid.to_i
    ( render :json => weather; return ) if map.nil?

    all = []
    Weather.where(map_id: mid.to_i).each{|e| all << e if Time.now.to_i - e.created_at.to_i < DAY_SECONDS }

    if all.empty?
      weather = WeatherWrapper::API.get_weather_by(map.name)
      ( render :json => weather; return ) if weather.nil?

      entity = weather.merge({ map_id: 1 })
      Weather.create entity
    else
      w = all.first
      weather = {
        tmp_current:  w.tmp_current,  tmp_today:  w.tmp_today,
        tmp_desc:     w.tmp_desc,     tmp_wind:   w.tmp_wind,
        tmp_pic_from: w.tmp_pic_from, tmp_pic_to: w.tmp_pic_to,
        tmp_humidity: w.tmp_humidity
      }
    end

    render :json => weather
  end

end