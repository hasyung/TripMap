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

  def set_error_msg( yml_path )
    { error_msg: I18n.t(yml_path) }
  end

end