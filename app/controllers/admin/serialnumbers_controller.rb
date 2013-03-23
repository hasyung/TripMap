class Admin::SerialnumbersController < Admin::ApplicationController
  def index
    @serials = MapSerialNumber.page(params[:page]).per(Setting.page_size).created_desc
    @serial = MapSerialNumber.new
    add_breadcrumb :index
  end

  def export
    @serials = MapSerialNumber.all
    @content =""
    @serials.each do |s|
      @content += "#{s.code}\n"
      s.printed_cd = 1
      s.save
    end
    send_data @content, :type => 'text', :disposition => "attachment; filename=map_type_#{Time.now}.txt"
  end

  def search
    #@serials = data_search
    @serials = MapSerialNumber.where( :type_cd => params[:map_serial_number][:type_cd]).page(params[:page]).per(Setting.page_size).created_desc
    @serial  = MapSerialNumber.new

    add_breadcrumb :index
    render :index
  end

  private
  def get_datetime_by_string str
    if str.present?
      dates = str.split(" - ")
      dates[0] += " 00:00:00"
      dates[1] += " 23:59:59"
    end
  end

  def data_search
    conditions  = SmartTuple.new(" AND ")
    conditions << ["map_id = ?", params[:map_serial_number][:map_id]]   if params[:map_serial_number][:map_id].present?
    conditions << ["type_cd = ?", params[:map_serial_number][:type_cd]] if params[:map_serial_number][:type_cd].present?
    conditions << ["printed_cd = ?", params[:map_serial_number][:printed_cd]] if params[:map_serial_number][:printed_cd].present?
    
    # binding.pry
    str_date = get_datetime_by_string params[:date]
    if !str_date.blank?
      conditions << ["created_at >= ?", str_date[0]]
      conditions << ["created_at <= ?", str_date[1]]
    end
    # binding.pry
    map_serials = MapSerialNumber.where( conditions.compile ).page(params[:page]).
                  per(Setting.page_size).
                  created_desc
  end
end
