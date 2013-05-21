class Admin::SettingsController < Admin::ApplicationController
  
  def index
    if request.post?
      if params[:page_size].present? && params[:serial_devices_size].present?
        Setting.page_size = params[:page_size]
        Setting.serial_devices_size = params[:serial_devices_size]
      end
      
      redirect_to admin_settings_path, :notice => t("messages.settings.success")
    end
    add_breadcrumb :index
  end
end
