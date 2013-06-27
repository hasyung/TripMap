class Api::ApplicationController < ActionController::Base

  # Callbacks
  before_filter :set_default_response_format
  skip_before_filter :verify_authenticity_token

  respond_to :json

  # Methods
  protected

  def set_default_response_format
    request.format = 'json'.to_sym if params[:format].nil?
  end

  def has_nil_value_in( keys = [] )
    has_nil = false
    keys.each do |k|
      p = params[k.to_sym]
      break if has_nil = p.nil? || p.blank?
    end
    has_nil
  end

  def set_msg( yml_path )
    { msg: I18n.t(yml_path) }
  end

  def get_url( avi_model )
    ret = ""
    return ret if avi_model.nil?
    ret = avi_model.file.url if avi_model.file.present?
    ret
  end
  
  def get_file_value( file, field, url = false )
    is_file_blank = file.blank? || file.send(field.to_sym).blank?
    is_zero_type = ( field == "file_size" || field == "duration" )

    ( return is_zero_type ? 0 : "" ) if is_file_blank

    result = url ? file.send(field.to_sym).url : file.send(field.to_sym)
  end

end