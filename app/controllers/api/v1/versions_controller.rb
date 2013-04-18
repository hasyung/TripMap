class Api::V1::VersionsController < Api::V1::ApplicationController

  def check
    pf = params[:platform]
    ( render :json => {}; return ) if pf.nil?

    versions = Version.where("platform=?", pf.to_i)
    ( render :json => {}; return ) if versions.empty?

    versions.sort_by!{ |o| o.value }.reverse!

    render :json => { version: versions.first.value }
  end

end