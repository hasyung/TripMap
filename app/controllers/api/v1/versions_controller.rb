require 'app/common'

class Api::V1::VersionsController < Api::V1::ApplicationController
  include App::Common

  def check
    pf = params[:platform]
    ( render :json => {}; return ) if pf.nil? or pf.match(/^\d+$/).nil?

    latest_version = Version.where(platform: pf.to_i).sort_by{|e| e.value}.last

    ( render :json => {}; return ) if latest_version.nil?

    render :json => {
     version: latest_version.value,
     app:     pf.to_i == PLATFORM[:iOS] ? latest_version.url.to_s : latest_version.app.url.to_s,
     desc:    latest_version.description,
    }
  end

end