class Admin::DownloadsController < Admin::ApplicationController
  skip_before_filter :authenticate_user!

  def d
    plist = params[:plist]
    address = "itms-services://?action=download-manifest&url=http://m.1trip.com/downloads/ios/%s"%plist
    ( redirect_to address; return ) unless plist.nil?

    render :layout => false
  end

end