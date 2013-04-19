# encoding:utf-8

require 'httpclient'
require 'nokogiri'

module Weather

  class API
    WS_URL = "http://www.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName"

    def self.get_suit_weather( city_name )
      ws_req_url = WS_URL + "?theCityName=" + URI.escape(city_name)
      response = HTTPClient.new.get(ws_req_url).body

      doc = Nokogiri.XML(response.gsub(/\n/, '').gsub(/\r/, ''))
      return {} if doc.children.empty?

      all = []
      doc.children[0].children.each{ |e| all << e.text if not e.text.strip.empty? }
      line10 = all[10].split('；')

      results = {
       tmp_current:   line10[0].split('：')[2],  tmp_today:  all[5],
       tmp_desc:      all[6].split(' ')[1],     tmp_wind:   line10[1].split('：')[1],
       tmp_pic_from:  all[8].delete('.gif'),    tmp_pic_to: all[9].delete('.gif'),
       tmp_humidity:  line10[2].split('：')[1]
      }
    end
  end

end