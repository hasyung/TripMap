class Api::V1::DownloadsController < Api::V1::ApplicationController
  
  def count
    d = Download.first

    if d.nil?
      entity = Download.new :count => 1
      entity.save
    end

    d.count += 1
    d.save

    render :text => d.count.to_s

  end

end