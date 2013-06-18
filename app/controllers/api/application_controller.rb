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

end