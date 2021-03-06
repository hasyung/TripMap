# encoding:utf-8

class Api::V1::AccountsController < Api::V1::ApplicationController

  def show
    result = { nickname: "游客", result: false }
    (render :json => result; return) if params[:email].blank?

    account = Account.find{|a| a.email == params[:email].downcase}
    result = {nickname: account.nickname, result: true} if account.present?

    render :json => result
  end

  def create
    result = { result: 6 }
    fields = ['device_id', 'email', 'password', 'nickname']

    ( result = { result: 1 }; render :json => result; return ) if has_nil_value_in fields

    ( result = { result: 2 }; render :json => result; return ) if Account.find{ |o| o.email == params[:email].downcase}.present?
    ( result = { result: 3 }; render :json => result; return ) if Account.find{ |o| o.nickname == params[:nickname] }.present?

    if params[:serial].present?
      serial = MapSerialNumber.where("code = '#{params[:serial]}'").first
      ( result = { result: 4 }; render :json => result; return ) if serial.blank?
      ( result = { result: 5 }; render :json => result; return ) if serial.activate_cd == 1
    end

    activate_map = ActivateMap.find{ |o| o.device_id == params[:device_id] }
    activate_map = ActivateMap.create(device_id: params[:device_id]) if activate_map.blank?

    account = activate_map.accounts.new email: params[:email], password: params[:password], password_confirmation: params[:password], nickname: params[:nickname]
    if activate_map.save
      if serial.present?
        serial.account_id = account.id
        serial.activate_cd = 1
        serial.save
      end
      result = {result: 0}
    end

    render :json => result
  end

  def update
    fields = ['email', 'password', 'nickname']
    ( result = { result: 1 }; render :json => result; return ) if has_nil_value_in fields

    result = { result: 4 }
    account = Account.find{|a| a.email == params[:email].downcase}
    ( result = { result: 2 }; render :json => result; return ) if account.blank? || !account.valid_password?(params[:password])
    ( result = { result: 3 }; render :json => result; return ) if Account.find{ |o| o.nickname == params[:nickname] }.present?
    account.nickname = params[:nickname]
    account.password = account.password_confirmation = params[:password]
    result = { result: 0 } if account.save

    render :json => result
  end

  def login
    fields = ['device_id', 'email', 'password']
    ( result = { result: 1 }; render :json => result; return ) if has_nil_value_in fields

    result = { result: 4 }

    account = Account.find_by_email(params[:email].downcase, include: [:activate_maps]) 
    ( result = { result: 2 }; render :json => result; return ) if account.blank? ||!account.valid_password?(params[:password])
    ( result = { result: 3 }; render :json => result; return ) if account.activate_maps.count >= 10

    activate_map = ActivateMap.find_by_device_id(params[:device_id], include: [:accounts])
    activate_map = ActivateMap.create(device_id: params[:device_id]) if activate_map.blank?
    activate_map.accounts << account if !activate_map.accounts.include?(account)
    result = { result: 0, nickname: account.nickname }

    render :json => result
  end

  def validate
    fields = ['email', 'serial']
    ( result = { result: 1 }; render :json => result; return ) if has_nil_value_in fields

    result = { result: 6 }
    account = Account.find_by_email(params[:email].downcase, include: [:map_serial_number]) 
    ( result = { result: 2 }; render :json => result; return ) if account.blank?

    serial = MapSerialNumber.where("code = '#{params[:serial]}'").first
    ( result = { result: 3 }; render :json => result; return ) if serial.blank?
    ( result = { result: 4 }; render :json => result; return ) if serial.activate_cd == 1

    ( result = { result: 5 }; render :json => result; return ) if account.map_serial_number.present?

    serial.account_id = account.id
    serial.activate_cd = 1
    serial.save
    result = {result: 0}

    render :json => result
  end

end