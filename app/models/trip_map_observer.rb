class TripMapObserver < ActiveRecord::Observer
  observe :scenic, :place, :recommend,                    # Level 1.
          :recommend_record, :recommend_detailed,         # Level 2.
          :image_list,
          :audio, :video, :image, :letter                 # Atom.
  
  NAV_PATH_OPTIONS = {
    #class name        path to map
    :Scenic             => "map",
    :Place              => "map",
    :Recommend          => "map",

    :RecommendRecord    => "recommend.map",
    :RecommendDetailed  => "recommend_record.recommend.map",

    :ImageList          => "recommend_detailed.recommend_record.recommend.map",
  }

  POLIABLE_NAME_OPTIONS = {
    :Video              => "videoable",
    :Audio              => "audioable",
    :Image              => "imageable",
    :Letter             => "textable"
  }
  
  def after_save( model )
    update_map_version(get_map(model))
  end

  def after_destroy( model )
    
  end

  private

  def update_map_version ( map_instance )
    return nil if map_instance.nil?
    
    map_instance.version = Time.now.to_i
    map_instance.save
  end
  
  def get_map( model )
    map = nil
    kls_name = model.class.class_name
    poliable = get_poliable(kls_name)
    nav_path = nil
    
    if poliable.nil?
      nav_path = NAV_PATH_OPTIONS[ kls_name.to_sym ]
      map = get_map_by_path(model, nav_path)
    else
      ploy_type, ploy_type_id = "#{poliable}_type", "#{poliable}_id"
      bind_to = model.send(ploy_type)
      ploy_object = bind_to.constantize.find model.send(ploy_type_id)

      nav_path = NAV_PATH_OPTIONS[ bind_to.to_sym ]
      map = get_map_by_path(ploy_object, nav_path)
    end

    map
  end
  
  def get_map_by_path( ploy_object, path )
    map = ploy_object
    navs = path.split(".")
    navs.each{|curr_path| map = map.send curr_path }

    map
  end

  def get_poliable( model_kls_name )
    POLIABLE_NAME_OPTIONS[ model_kls_name.to_sym ]
  end
  
end
