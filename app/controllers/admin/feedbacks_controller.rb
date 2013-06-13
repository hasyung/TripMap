class Admin::FeedbacksController < Admin::ApplicationController

  def index
    @feedbacks = Feedback.includes(:account).page(params[:page]).per(Setting.page_size).created_desc
    add_breadcrumb :index
  end

  def show
    @feedback = Feedback.find params[:id]
    add_breadcrumb :index
  end

end