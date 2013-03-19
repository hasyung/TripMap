class Admin::RecommendRecordsController < Admin::ApplicationController
  def index
    recommend = Recommend.find params[:recommend_id] 
    @records = recommend.recommend_records.page(params[:page]).per(Setting.page_size).order_asc
    
    add_breadcrumb :index
  end

  def new
    @record = RecommendRecord.new

    add_breadcrumb :new
  end

  def create
    recommend = Recommend.find params[:recommend_id]
    @record = recommend.recommend_records.new params[:recommend_record]
    if @record.save
      redirect_to admin_recommend_records_path,
                  notice: t('messages.recommend_records.success')
    else
      render :new
    end
  end

  def edit
    #@recommend = Recommend.find params[:recommend_id]
    @record = RecommendRecord.find params[:id]
    
    add_breadcrumb :edit
  end

  def update
    @record = RecommendRecord.find params[:id]
    if @record.update_attributes params[:recommend_record]
       redirect_to admin_recommend_records_path(@record.recommend),
                  notice: t('messages.recommend_records.success')
    else
      render :edit
    end
  end

  def destroy
    record = RecommendRecord.find params[:id]
    if record.destroy
      redirect_to admin_recommend_records_path,
                  notice: t('messages.recommend_records.success')
    else
      redirect_to admin_recommend_records_path,
                  notice: t('messages.recommend_records.error')
    end

  end
end
