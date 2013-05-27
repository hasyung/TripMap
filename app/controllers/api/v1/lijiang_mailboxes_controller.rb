class Api::V1::LijiangMailboxesController < Api::V1::ApplicationController

   def create
    ret = { result: false }

    fields = ['device_id', 'service_score', 'env_score', 'category']
    (render :json => ret.merge(set_msg("errors.api.lijiang_mailboxes.invalid_params")); return) if has_nil_value_in fields

    if params[:service_score] !~ /^[0-9]+$/ || params[:env_score] !~ /^[0-9]+$/ || params[:category] !~ /^[0-9]+$/ 
      error = set_msg("errors.api.lijiang_mailboxes.invalid_params")
      render :json => ret.merge(error); return
    end

    [:action, :controller, :format].each{|k| params.delete(k)}
    insts = LijiangMailbox.new params
    ret[:result] = true if insts.save

    render :json => ret.merge(set_msg("tips.api.success"))
   end

end