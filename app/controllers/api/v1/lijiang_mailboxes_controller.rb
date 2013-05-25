class Api::V1::LijiangMailboxesController < Api::V1::ApplicationController

   def create
    ret = { status: false }

    fields = ['device_id', 'service_score', 'env_score', 'category']
    if has_nil_value_in fields
      error = set_error_msg("errors.api.lijiang_mailboxes.invalid_params")
      render :json => ret.merge(error); return
    end

    if params[:service_score] !~ /^[0-9]+$/ || params[:env_score] !~ /^[0-9]+$/ || params[:category] !~ /^[0-9]+$/ 
      error = set_error_msg("errors.api.lijiang_mailboxes.invalid_params")
      render :json => ret.merge(error); return
    end

    [:action, :controller, :format].each{|k| params.delete(k)}
    insts = LijiangMailbox.new params
    ret = { status: true } if insts.save

    render :json => ret
   end

end