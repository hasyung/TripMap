class Admin::SerialnumbersController < Admin::ApplicationController
  before_filter :is_admin

  def index
    @serials = MapSerialNumber.page(params[:page]).per(Setting.page_size).created_desc
    @serial = MapSerialNumber.new
    add_breadcrumb :index
  end

  def export
    @serial = MapSerialNumber.new
    add_breadcrumb :index
  end

  def ex_search
    conditions = data_search params[:map_serial_number][:map_id],
                             params[:map_serial_number][:type_cd],
                             0,
                             nil

    @serials = MapSerialNumber.where( conditions.compile ).limit(params[:sum].to_i)
    if @serials.count == params[:sum].to_i      
      @serials.transaction do
          map = Map.find params[:map_serial_number][:map_id]
          serial_type =  I18n.t("enums.mapserialnumber.type.#{MapSerialNumber.types.key(params[:map_serial_number][:type_cd].to_i)}")
          @serial_name = "#{map.name}_#{serial_type}_#{MapSerialNumber.human_attribute_name(:sum)}(#{params[:sum]})"
          MapSerialNumber.where(id: @serials.map(&:id)).update_all( printed_cd:1 )

          file_xls = render_to_string
          path = "export/download/#{@serial_name}_#{Time.now}.xls"
          if !File.exist?("export/download/")
            Dir.mkdir("export")
            Dir.mkdir("export/download")
          end
          File.open(path, "w"){ |f| f.write(file_xls) }
      end
      redirect_to export_admin_serialnumbers_path, notice: t('messages.serialnumbers.export')
    elsif @serials.count < params[:sum].to_i
        redirect_to export_admin_serialnumbers_path, notice: t('messages.serialnumbers.sum', sum: @serials.count )
    else
      redirect_to export_admin_serialnumbers_path, notice: t('messages.serialnumbers.error')
    end

  end

  def search
    conditions = data_search params[:map_serial_number][:map_id],
                             params[:map_serial_number][:type_cd],
                             params[:map_serial_number][:printed_cd],
                             params[:date]

    @serials = MapSerialNumber.where( conditions.compile ).page(params[:page]).
                  per(Setting.page_size).
                  created_desc
    params[:commit], params[:utf8] = nil
    @serial  = MapSerialNumber.new params[:map_serial_number]
    add_breadcrumb :index
    render :index
  end

  private
  def get_datetime_by_string str
    dates = Array.new
    dates = str.split(" - ") if str.present?
  end

  def data_search (map_id, type_cd, printed_cd, date)
    conditions  = SmartTuple.new(" AND ")
    conditions << ["map_id = ?",  map_id ]      if map_id.present?
    conditions << ["type_cd = ?", type_cd]      if type_cd.present?
    conditions << ["printed_cd = ?",printed_cd] if printed_cd.present?
    str_date = get_datetime_by_string date
    if !str_date.blank?
      conditions << ["created_at >= ?", str_date[0].to_time]
      conditions << ["created_at <= ?", (str_date[1]+" 23:59:59").to_time]
    end

    conditions
  end

  def is_admin
    redirect_to admin_root_path, notice: t('messages.serialnumbers.purview') if current_user.email != "admin@1trip.com"
  end
end
