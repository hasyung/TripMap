#encoding: utf-8

require 'weather/api'

class Api::V1::WeathersController < Api::V1::ApplicationController

  DAY_SECONDS = 24 * 60 * 60

  def index
    weather = {
      tmp_current:  "20℃",  tmp_today:  " 16℃/30℃",
      tmp_desc:     "多云",  tmp_wind:   "南风 2级",
      tmp_pic_from: "1", tmp_pic_to: "1",
      tmp_humidity: "73%"
    }

    render :json => weather
  end

end