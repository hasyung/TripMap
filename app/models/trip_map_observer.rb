class TripMapObserver < ActiveRecord::Observer
  observe :scenic, :place, :recommend, :recommend_record, :recommend_detailed,
          :audio, :video, :image, :image_list, :letter
          
  def after_create( model )
    which_map = get_map_instance(model)
    update_map_version(which_map)
  end

  def after_update( model )
    which_map = get_map_instance(model)
    update_map_version(which_map)
  end

  def after_destroy( model )
    which_map = get_map_instance(model)
    update_map_version(which_map)
  end

  private

  def update_map_version ( map_instance )
    return nil if map_instance.nil?
    
    map_instance.version = Time.now.to_i
    map_instance.save
  end

  def get_map_instance( model )
    map_instance = nil

    kls_name = model.class.class_name
    kls_set_level1 = %w(Scenic Place Recommend)
    kls_set_level2 = %w(RecommendRecord RecommendDetailed)

    if kls_set_level1.include?(kls_name)
    map_instance = model.map
    elsif kls_set_level2.include?(kls_name)
      map_instance = model.recommend.map if kls_name == "RecommendRecord"
      map_instance = model.recommend_record.recommend.map if kls_name == "RecommendDetailed"
    else
      map_instance = get_map_by_video(model, kls_set_level1, kls_name)  if kls_name == "Video"
      map_instance = get_map_by_audio(model, kls_set_level1, kls_name)  if kls_name == "Audio"
      map_instance = get_map_by_image(model, kls_set_level1, kls_name)  if kls_name == "Image"
      map_instance = get_map_by_text(model, kls_set_level1, kls_name)   if kls_name == "Letter"
    end

    map_instance
  end

  def get_map_by_video( model, level1, kls_name )
    video = model.videoable_type.constantize.find model.videoable_id
    video_bind_to = model.videoable_type
    map_instance = video.map if level1.include?(video_bind_to)
    map_instance = video.recommend_record.recommend.map if kls_name == "RecommendDetailed"
    map_instance
  end

  def get_map_by_audio( model, level1, kls_name )
    audio = model.audioable_type.constantize.find model.audioable_id
    audio_bind_to = model.audioable_type
    map_instance = audio.map if level1.include?(audio_bind_to)
    map_instance = audio.recommend_record.recommend.map if kls_name == "RecommendDetailed"
  end

  def get_map_by_image( model, level1, kls_name )
    img = model.imageable_type.constantize.find model.imageable_id
    img_bind_to = model.imageable_type
    map_instance = img.map if level1.include?(img_bind_to)
    map_instance = img if img_bind_to == "Map"
    map_instance = img.recommend_record.recommend.map if kls_name == "RecommendDetailed"
    map_instance = img.recommend_detailed.recommend_record.recommend.map if img_bind_to == "ImageList"
    map_instance
  end

  def get_map_by_text( model, level1, kls_name )
    txt = model.textable_type.constantize.find model.textable_id
    txt_bind_to = model.textable_type
    map_instance = txt.map if level1.include?(txt_bind_to)
    map_instance = txt if txt_bind_to == "Map"
    map_instance = txt.recommend.map if txt_bind_to == "RecommendRecord"
    map_instance = txt.recommend_record.recommend.map if kls_name == "RecommendDetailed"
    map_instance
  end

end
