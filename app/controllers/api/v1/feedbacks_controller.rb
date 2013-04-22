class Api::V1::FeedbacksController < Api::V1::ApplicationController

  def create
    ret = {result: false}

    (render :json => ret; return) if params[:feedback].blank?

    account = Account.find_by_email(params[:email]) if params[:email].present?
    if account.present?
      feedback = account.feedbacks.new body: params[:feedback]
    else
      feedback = Feedback.new body: params[:feedback]
    end

    ret = {result: true} if feedback.save

    render :json => ret
  end

end