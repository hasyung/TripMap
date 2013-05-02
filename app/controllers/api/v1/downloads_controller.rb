class Api::V1::DownloadsController < Api::V1::ApplicationController

  def count
    d = Download.first

    if d.nil?
      d = Download.new :count => 1
      d.save
    else
      d.count = d.count + 1
      d.save
    end

    render :text => d.count.to_s

  end

end