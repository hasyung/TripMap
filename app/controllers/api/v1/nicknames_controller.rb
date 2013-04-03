class Api::V1::NicknamesController < Api::V1::ApplicationController

	def show
    result = {}
    (render :json => result; return) if params[:serial].nil?

    serial = MapSerialNumber.find{|num| num.code == params[:serial]}
    is_present = serial.present? and serial.nickname.present?
    result = {id: serial.nickname.id, nickname: serial.nickname.name} if is_present

    render :json => result
  end

	def create
		result = {result: false}

		nickname = params[:nickname]
    is_invalid_params = params[:serial].nil? or nickname.nil?
    (render :json => result; return) if is_invalid_params

		serial = MapSerialNumber.find{ |o| o.code == params[:serial] }
    is_present = serial.present? and serial.nickname.blank? and Nickname.find{ |o| o.name == nickname }.blank?

		if is_present
			serial.build_nickname nickname: params[:nickname]
			result = {result: true} if serial.save
		end

		render :json => result
	end

end