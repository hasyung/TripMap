class Admin::RecommendDetailedsController < Admin::ApplicationController

  def index
    record = RecommendRecord.find params[:record_id]
    @detaileds = record.recommend_detaileds.page(params[:page]).per(Setting.page_size).order_asc

    add_breadcrumb :index
  end

  def new
    recommend = Recommend.find params[:recommend_id]
    @record = recommend.recommend_records.find params[:record_id]
    @detailed = @record.recommend_detaileds.new

    add_breadcrumb :new
  end

  def create
    record = RecommendRecord.find params[:record_id]
    @detailed = record.recommend_detaileds.new params[:recommend_detailed]
    if @detailed.save
      redirect_to admin_recommend_record_detaileds_path(
                  params[:recommend_id],
                  params[:record_id]),
                  notice: t('messages.recommend_detaileds.success')
    else
      render :new
    end
  end

  def edit
    recommend = Recommend.find params[:recommend_id]
    @record = recommend.recommend_records.find params[:record_id]
    @detailed = @record.recommend_detaileds.find params[:id]

    add_breadcrumb :edit
  end

  def update
    @detailed = RecommendDetailed.find params[:id]

    if @detailed.update_attributes params[:recommend_detailed]
      redirect_to admin_recommend_record_detaileds_path(
                  params[:recommend_id],
                  params[:record_id]),
                  notice: t('messages.recommend_detaileds.success')
    else
      render :edit
    end
  end

  def destroy
    detailed = RecommendDetailed.find params[:id]
    if detailed.destroy
      redirect_to admin_recommend_record_detaileds_path(
                  params[:recommend_id],
                  params[:record_id]),
                  notice: t('messages.recommend_detaileds.success')
    else
      redirect_to admin_recommend_record_detaileds_path(
                  params[:recommend_id],                  
                  params[:record_id]),
                  notice: t('messages.recommend_detaileds.error')
    end
  end

  def show
    @detailed = RecommendDetailed.find params[:id]
    @videos = @detailed.videos
    @audios = @detailed.audios
    @images = @detailed.images
    @texts  = @detailed.texts
    @imagelists = @detailed.image_lists.all

    add_breadcrumb :show
  end

  def new_video
    recommend = Recommend.find params[:recommend_id]
    @record = recommend.recommend_records.find params[:record_id]
    @detailed = RecommendDetailed.find params[:detailed_id]
    @video = @detailed.videos.new
  end

  def create_video    
    @detailed = RecommendDetailed.find params[:detailed_id]
    @video = @detailed.videos.new params[:video]
    if @video.save
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.video.success')
    else
      render :new_video
    end
  end

  def edit_video
    @detailed = RecommendDetailed.find params[:detailed_id]
    @video = @detailed.videos.find params[:id]
  end

  def update_video
    @detailed = RecommendDetailed.find params[:detailed_id]
    @video = @detailed.videos.find params[:id]
    if @video.update_attributes params[:video]
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.video.success')
    else
      render :edit_video
    end
  end

  def destroy_video
    @video = Video.find params[:id]
    binding.pry
    if @video.destroy
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.video.success')
    else
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.video.error')
    end
  end

  def new_audio
    recommend = Recommend.find params[:recommend_id]
    @record = recommend.recommend_records.find params[:record_id]
    @detailed = RecommendDetailed.find params[:detailed_id]
    @audio = @detailed.audios.new
  end

  def create_audio    
    @detailed = RecommendDetailed.find params[:detailed_id]
    @audio = @detailed.audios.new params[:audio]
    if @audio.save
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.audio.success')
    else
      render :new_audio
    end
  end

  def edit_audio
    @detailed = RecommendDetailed.find params[:detailed_id]
    @audio = @detailed.audios.find params[:id]
  end

  def update_audio
    @detailed = RecommendDetailed.find params[:detailed_id]
    @audio = @detailed.audios.find params[:id]
    if @audio.update_attributes params[:audio]
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.audio.success')
    else
      render :edit_audio
    end
  end

  def destroy_audio
    @audio = Audio.find params[:id]
    if @audio.destroy
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.success')
    else
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.image.success')
    end
  end

  def new_image
    recommend = Recommend.find params[:recommend_id]
    @record = recommend.recommend_records.find params[:record_id]
    @detailed = RecommendDetailed.find params[:detailed_id]
    @image = @detailed.images.new
  end

  def create_image    
    @detailed = RecommendDetailed.find params[:detailed_id]
    @image = @detailed.images.new params[:image]
    if @image.save
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.image.success')
    else
      render :new_image
    end
  end

  def edit_image
    @detailed = RecommendDetailed.find params[:detailed_id]
    @image = @detailed.images.find params[:id]
  end

  def update_image
    @detailed = RecommendDetailed.find params[:detailed_id]
    @image = @detailed.images.find params[:id]
    if @image.update_attributes params[:image]
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.image.success')
    else
      render :edit_image
    end
  end

  def destroy_image
    @image = Image.find params[:id]
    if @image.destroy
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.image.success')
    else
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.image.error')
    end
  end

  def new_text
    recommend = Recommend.find params[:recommend_id]
    @record = recommend.recommend_records.find params[:record_id]
    @detailed = RecommendDetailed.find params[:detailed_id]
    @text = @detailed.texts.new
  end

  def create_text    
    @detailed = RecommendDetailed.find params[:detailed_id]
    @text = @detailed.texts.new params[:context]
    if @text.save
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.text.success')
    else
      render :new_text
    end
  end

  def edit_text
    @detailed = RecommendDetailed.find params[:detailed_id]
    @text = @detailed.texts.find params[:id]
  end

  def update_text
    @detailed = RecommendDetailed.find params[:detailed_id]
    @text = @detailed.texts.find params[:id]
    if @text.update_attributes params[:context]
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.text.success')
    else
      render :edit_text
    end
  end

  def destroy_text
    @text = Context.find params[:id]
    if @text.destroy
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.text.success')
    else
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.text.error')
    end
  end

  def new_imagelist
    recommend = Recommend.find params[:recommend_id]
    @record = recommend.recommend_records.find params[:record_id]
    @detailed = RecommendDetailed.find params[:detailed_id]
    @imagelist = @detailed.image_lists.new
  end

  def create_imagelist    
    @detailed = RecommendDetailed.find params[:detailed_id]
    @imagelist = @detailed.image_lists.new params[:image_list]
    if @imagelist.save
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.images.success')
    else
      render :new_imagelist
    end
  end

  def edit_imagelist
    @detailed = RecommendDetailed.find params[:detailed_id]
    @imagelist = @detailed.image_lists.find params[:id]
  end

  def update_imagelist
    @detailed = RecommendDetailed.find params[:detailed_id]
    @imagelist = @detailed.image_lists.find params[:id]
    if @imagelist.update_attributes params[:image_list]
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.images.success')
    else
      render :edit_imagelist
    end
  end

  def destroy_imagelist
    @imagelist = ImageList.find params[:id]
    if @imagelist.destroy
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.images.success')
    else
      redirect_to admin_recommend_record_detailed_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id]),
                  notice: t('messages.recommend_detaileds.images.success')
    end
  end

  def images
    @imagelist = ImageList.find params[:id]
    @images = @imagelist.images
  end

  def new_images
    @imageslist = ImageList.find params[:image_id]
    @image = @imageslist.images.new
  end

  def create_images
    @imagelist = ImageList.find params[:image_id]
    @image = @imagelist.images.new params[:image]
    binding.pry
    if @image.save
      redirect_to admin_recommend_record_detailed_imageslist_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id],
                  params[:image_id]),
                  notice: t('messages.recommend_detaileds.images.success')
    else
      render :new_images
    end
  end

  def edit_images
    @image = Image.find params[:id]
  end

  def update_images
    @image = Image.find params[:id]
    if @image.update_attributes params[:image]
      redirect_to admin_recommend_record_detailed_imageslist_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id],
                  params[:image_id]),
                  notice: t('messages.recommend_detaileds.images.success')
    else
      render :edit_images
    end
  end

  def destroy_images
    @image = Image.find params[:id]
    if @image.destroy
      redirect_to admin_recommend_record_detailed_imageslist_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id],
                  params[:image_id]),
                  notice: t('messages.recommend_detaileds.images.success')
    else
      redirect_to admin_recommend_record_detailed_imageslist_path(
                  params[:recommend_id],
                  params[:record_id],
                  params[:detailed_id],
                  params[:image_id]),
                  notice: t('messages.recommend_detaileds.images.error')
    end
  end
end
