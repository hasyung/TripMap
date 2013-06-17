class Api::V1::DeclarationsController < Api::V1::ApplicationController

  def show
    result = { declaration: Declaration.all.present? ? Declaration.first.body : "" }
    render :json => result
  end

end