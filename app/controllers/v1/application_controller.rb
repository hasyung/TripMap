class V1::ApplicationController < ActionController::Base
	
  	before_filter :set_default_response_format
  	skip_before_filter :verify_authenticity_token
  
  	respond_to :json
  
  	protected
    def set_default_response_format
      request.format = 'json'.to_sym if params[:format].nil?
    end

    def get_file_value(file, meth_name,url)
      if file.present?
        if url
          result = file.send(meth_name.to_sym).url
        else
          result = file.send(meth_name.to_sym)
        end
      else
        result= ""
      end
      result
    end
end
