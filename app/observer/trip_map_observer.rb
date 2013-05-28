class TripMapObserver < ActiveRecord::Observer

  # Observing models.
  observe :scenic, :place, :recommend, :info_list, :panel_video,      # Level 1.
          :recommend_record, :recommend_detailed, :info,              # Level 2.
          :image_list,
          :audio, :video, :image, :letter                             # Atom.

  NAV_PATH_OPTIONS = {
    # class name           path to map
    :Scenic             => "map",
    :Place              => "map",
    :Recommend          => "map",
    :InfoList           => "map",
    :PanelVideo         => "map",

    :Info               => "info_list.map",
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
    update_map_version(model)
  end

  def after_destroy( model )
    update_map_version(model)
  end

  private

  def update_map_version ( model )
    map_instance = get_map(model)
    return nil if map_instance.nil?

    Rails.cache.write("map_#{map_instance.id}", map_instance.get_map_values)

    map_instance.version = Time.now.to_i
    map_instance.save
  end

  def get_map( model )
    map = nil
    kls_name = model.class.to_s

    poliable = POLIABLE_NAME_OPTIONS[ kls_name.to_sym ]
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
    return nil if path.nil?

    map = ploy_object
    navs = path.split(".")
    navs.each{|curr_path| map = map.send curr_path }

    map
  end

end