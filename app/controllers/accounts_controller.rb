class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    serial_num = params[:account][:map_serial_number_attributes][:code]
    if serial_num.present?
      binding.pry
      serial = MapSerialNumber.where("code = #{serial_num}").first
      (redirect_to new_accounts_path(params[:device_id]), :alert => t("messages.accounts.serial_error"); return) if serial.blank? ||
                                                                                            serial.activate_cd == 1
    end

    activate_map = ActivateMap.find{ |o| o.device_id == params[:device_id] }
    activate_map = ActivateMap.create(device_id: params[:device_id]) if activate_map.blank?
    @account = activate_map.accounts.new params[:account]
    if activate_map.save
      if serial.present?
        serial.account_id = @account.id
        serial.activate_cd = 1
        serial.save
      end
      redirect_to success_accounts_path
    else
      render :new
    end
  end

  def success

  end
end