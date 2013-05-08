class Api::V1::DownloadsController < Api::V1::ApplicationController

  def count
    type = params[:type]
    ( return render :text => "-1" ) if type.nil?

    d = Download.get_downloads(type.to_i).first

    if d.nil?
      d = Download.new :count => 1, :type => type.to_i
      d.save
    else
      d.count = d.count + 1
      d.save
    end

    render :text => d.count.to_s

  end

end