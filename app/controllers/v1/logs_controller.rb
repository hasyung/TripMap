class V1::LogsController < V1::ApplicationController

	def create
		activate_map = ActivateMap.find {|a| a.device_id == params[:device_id]}
		activate_map.logs.new map_id: params[:map_id].to_i,
														 device_type_cd: params[:device_type].to_i,
														 slug: params[:slug].downcase,
														 message_cd: params[:message].to_i
		if activate_map.save
      		result = {result: true}
    		else
      		result = {result: false}
    		end
    		render :json => result
	end

end