# encoding:utf-8

require 'weather/api'

class Admin::WeathersController < Admin::ApplicationController
  skip_before_filter :authenticate_user!

  UPDATE_SECONDS = 3 * 60 * 60
  DEFAULT_BG_IMG = "/assets/weather/images/default.png"

  def index
    fields = [ 'map_id' ]

    ( render :text => I18n.t("errors.weather.map_id"); return ) if has_nil_value_in fields

    mid = params[:map_id]
    @map = Map.find_by_id mid.to_i
    ( render :text => I18n.t("errors.weather.map_id"); return ) if @map.nil?
    bg_image = @map.map_weather_bg_image
    @map_bg_image = bg_image.nil? ? DEFAULT_BG_IMG : bg_image.file
    options = { weatherable_type: @map.class.to_s, weatherable_id: mid.to_i }

    all = get_today_weather(options)

    w = nil
    if all.empty?
      w = get_weather(@map.name, options)
      if w.nil?
        old_data = get_today_weather(options, true)
        ( render :text => I18n.t("errors.weather.disabled"); return ) if old_data.empty?
        w = old_data.last
      end
    else
      w = all.first
    end

    surr_cities = SurroundCity.where(map_id: mid.to_i)

    @surr_w = []
    unless surr_cities.empty?
      surr_cities.each do|city|
        ploy_options = { weatherable_type: city.class.to_s, weatherable_id: city.id }
        city_w = get_today_weather(ploy_options)

        if city_w.empty?
          c_w = get_weather(city.city_name, ploy_options)
          if c_w.nil?
            tmp_old_data = get_today_weather(ploy_options)
            next if tmp_old_data.empty?
            c_w = tmp_old_data.last
          end
          @surr_w << e_to_h(c_w, true).merge({ city_name: city.city_name })
        else
          @surr_w << e_to_h(city_w.first, true).merge({ city_name: city.city_name })
        end
      end
    end

    @weather = e_to_h(w)

    render :layout => false
  end

  def get_weather( city_name, ploy_options )
    weather = WeatherWrapper::API.get_weather_by(city_name)

    return nil if weather.empty? or weather.has_value?(nil)
    entity = weather.merge( ploy_options )
    w = Weather.create entity
    w
  end

  def e_to_h( weather_entity, isExtendModel = false )
    w = weather_entity
    tw = w.tmp_today.split('/')

    ret = isExtendModel ? { tmp_today_low: tw[0], tmp_today_high: tw[1], tmp_pic_to: w.tmp_pic_to } :
          {
            tmp_current:  w.tmp_current,  tmp_today_low: tw[0], tmp_today_high: tw[1],
            tmp_desc:     w.tmp_desc,     tmp_wind:   w.tmp_wind,
            tmp_pic_from: w.tmp_pic_from, tmp_pic_to: w.tmp_pic_to,
            tmp_humidity: w.tmp_humidity
          }
  end

  def get_today_weather( ploy_options, isUseOldData = false )
    ret = isUseOldData ? w_arr = Weather.where(ploy_options) :
          Weather.where(ploy_options).select{|e| (Time.now.to_i - e.created_at.to_i) < UPDATE_SECONDS }
  end

  # Methods access scope declares
  private :get_weather, :e_to_h, :get_today_weather
end