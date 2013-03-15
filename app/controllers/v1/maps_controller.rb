class V1::MapsController < V1::ApplicationController
    
    def index
    		result = []
    		Map.all.each do |map|
    			if !map.map_description.blank?   			
    				result << {:id => map.id, :name => map.name, :cover => map.map_cover.file.url, :description => map.map_description.body}
    			else
    				result << {:id => map.id, :name => map.name, :cover => map.map_cover.file.url, :description => ""}
    			end
    		end
    		render :json => result
  	end

  	def validate
  		param = { map_id: params[:id], serial: params[:serial] }
  		if MapSerialNumber.all.find{|num| num.map_id ==  param.map_id, num.code == param.serial}.blank?
  			result = false
  		else
  			result = true
  		end
  		render :json => result
  	end	

end
