class Api::V1::VersionsController < Api::V1::ApplicationController

  def check
    pf = params[:platform]
    ( render :json => {}; return ) if pf.nil? or pf.match(/^\d+$/).nil?

    versions = Version.where( platform: pf.to_i ).map(&:value)
    ( render :json => {}; return ) if versions.empty?

    render :json => { version: versions.max }
  end

end