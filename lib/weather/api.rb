# encoding:utf-8

module Weather
  class API

    # 根据城市或地区名称查询获得现在的天气实况
    def self.get_suit_weather(the_city_name)
      the_city_name =  URI.escape(the_city_name)
      service = "http://www.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName?theCityName=" + the_city_name
      client = HTTPClient.new
      body = client.get(service).body
      if body.split("string")[1].delete("<,>,/") == "查询结果为空！"
        return params = {}
      else
        params = {  :temp => body.split("string")[11].delete("<,>,/"),
                               :weath => body.split("string")[13].delete("<,>,/").split(" ")[1],
                               :picture => body.split("string")[17].delete("<,>,/").delete(".gif"),
                               :wind =>body.split("string")[21].delete("<,>,/").split("；")[1].split("：")[1]
                             }
        end
    end

  end
end