# encoding:utf-8

require 'httpclient'
require 'nokogiri'

module WeatherWrapper

	class YahooWeather
		WS_URL = "http://weather.yahooapis.com/forecastrss?u=c&"

		# 0...47, 3200
		EN_TO_CN = ["龙卷风", "热带风暴", "飓风", "严重的雷暴", "雷暴", "混合雨和雪", "混合雨和冰雹", "混合雪和冰雹", "冻结细雨", "细雨", "冻雨",
								"淋浴", "淋浴", "雪天", "小雪淋浴", "飞雪", "雪", "冰雹", "雨夹雪", "尘埃", "雾蒙蒙的", "霾", "烟", "大风", "风", "冷",
								"多云", "大部多云(晚上)", "大部多云(天)", "部分多云(晚上)", "部分多云(天)", "清晰(晚上)", "阳光", "公平(晚上)", "公平(天)", 
								"混合雨和冰雹", "热", "孤立的雷暴", "分散的雷雨", "分散的雷雨", "零星阵雨", "大雪", "散雪淋浴", "大雪", "局部多云", "雷阵雨",
								"阵雪", "孤立的雷阵雨", "不可用"]

		def self.get_weather_by( city_code )
			#http://weather.yahooapis.com/forecastrss?w=2160239&u=c
			ws_req_url = WS_URL + "w=" + city_code.to_s
			response = HTTPClient.new.get(ws_req_url).body

			doc = Nokogiri.XML(response)
			wc 	 = doc.xpath('//rss/channel/item/yweather:condition').first
			t 	 = doc.xpath('//rss/channel/item/yweather:forecast').first	
			wind = doc.xpath('//rss/channel/yweather:wind').first
			desc = doc.xpath('//rss/channel/item/description').first.to_s

			tmp_current 	= wc["temp"] + "°C"
			tmp_today 		= t["low"] + "°C ~ " + t["high"] + "°C"
			tmp_desc 			= EN_TO_CN[ t["code"].to_i ]
			tmp_wind 			= wind["speed"] + "级"
			img_tag 			= desc.gsub(/<img.*?\/>/).first
			tmp_pic 			= img_tag.gsub(/http(.*?).gif/).first
			tmp_humidity 	= doc.xpath('//rss/channel/yweather:atmosphere').first["humidity"] + "%"

			results = {
			 tmp_current:  tmp_current, tmp_today: 	tmp_today,
			 tmp_desc: 		 tmp_desc, 		tmp_wind: 	tmp_wind,
			 #tmp_pic_from: 0,						tmp_pic_to: 0,
			 tmp_pic: 		 tmp_pic,			tmp_humidity: 	tmp_humidity
			}
		end
	end

end