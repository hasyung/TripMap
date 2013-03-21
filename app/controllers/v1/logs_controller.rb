class V1::LogsController < V1::ApplicationController

	def create
		activate_map = ActivateMap.find {|a| a.device_id == params[:device_id]}
		log = activate_map.logs.new map_id: params[:map_id], device_type_cd: params[:device_type], slug: params[:slug], message_cd: params[:message]
		if log.save
      		result = {result: true}
    		else
      		result = {result: false}
    		end
    		render :json => result
	end

end