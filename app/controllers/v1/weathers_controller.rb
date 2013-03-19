class V1::WeathersController < V1::ApplicationController

	def index
		@map = Map.find params[:map_id]
		weathers = Weather::API.get_suit_weather(@map.name)
		render :json => weathers
	end

end