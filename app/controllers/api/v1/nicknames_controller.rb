class Api::V1::NicknamesController < Api::V1::ApplicationController
	def show
		result = {}
		serial = MapSerialNumber.find{|num| num.code == params[:serial]}
		if serial.present? && serial.nickname.present?
      		result << {nickname: serial.nickname.nickname}
    		end
    		render :json => result
	end

	def create
		result = {result: false}
		serial = MapSerialNumber.find{|num| num.code == params[:serial]}
		if serial.present? && Nickname.find{|n| n.nickname == params[:nickname]}.blank?
			serial.build_nickname nickname: params[:nickname]
			if serial.save
				result = {result: true}
			end
		end
		render :json => result
	end
end