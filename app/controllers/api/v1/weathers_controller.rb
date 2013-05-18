require 'weather/api'

class Api::V1::WeathersController < Api::V1::ApplicationController

  DAY_SECONDS = 24 * 60 * 60

  def index
    weather = { 
      tmp_current:  "20℃",  tmp_today:  " 16℃/30℃",
      tmp_desc:     "多云",  tmp_wind:   "南风 2级",
      tmp_pic_from: 1, tmp_pic_to: 1,
      tmp_humidity: "73%"
    }

    # mid = params[:map_id]
    # ( render :json => weather; return ) if mid.nil?
# 
    # map = Map.find_by_id mid.to_i
    # ( render :json => weather; return ) if map.nil?

    # all = Weather.where(map_id: mid.to_i).each{ |e| e.created_at.to_i < DAY_SECONDS }

    # if all.empty?
    #   weather = WeatherWrapper::API.get_weather_by(map.name)
    #   ( render :json => weather; return ) if weather.nil?

    #   entity = weather.merge({ map_id: 1 })
    #   Weather.create entity
    # else
    #   w = all.first
    # w = Weather.where(map_id: mid.to_i).first
    # weather = {
      # tmp_current:  w.tmp_current,  tmp_today:  w.tmp_today,
      # tmp_desc:     w.tmp_desc,     tmp_wind:   w.tmp_wind,
      # tmp_pic_from: w.tmp_pic_from, tmp_pic_to: w.tmp_pic_to,
      # tmp_humidity: w.tmp_humidity
    # }
    # end

    render :json => weather
  end

end