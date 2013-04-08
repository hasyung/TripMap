class Api::V1::WeathersController < Api::V1::ApplicationController

  def index
  	weathers = []
  	(render :json => result; return) if params[:map_id].blank?
    @map = Map.find_by_id params[:map_id]
    (render :json => weathers; return) if @map.blank?
    weathers = Weather::API.get_suit_weather(@map.name)
    render :json => weathers
  end

end