require "offline_package/trip_map_offline_package"

class TripMapObserver < ActiveRecord::Observer
  include TripMapOfflinePackage

  # Note: if observe's object changed, then NAV_PATH_OPTIONS should be changed together.

  # Observing models.
  observe :scenic, :place, :recommend, :info_list, :panel_video, :broadcast,  # Level 1.
          :audio_list_category, :first_known,

          :recommend_record, :recommend_detailed, :info, :children_broadcast, # Level 2.
          :audio_list, :first_known_list,

          :image_list, :audio_list_item,                                      # Level 3.

          :audio, :video, :image, :letter                                     # Atom.

  NAV_PATH_OPTIONS = {
    # class name           path to map
    :Scenic             => "map",
    :Place              => "map",
    :Recommend          => "map",
    :InfoList           => "map",
    :PanelVideo         => "map",
    :Broadcast          => "map",
    :AudioListCategory  => "map",
    :FirstKnown         => "map",

    :Info               => "info_list.map",
    :RecommendRecord    => "recommend.map",
    :RecommendDetailed  => "recommend_record.recommend.map",
    :ChildrenBroadcast  => "broadcast.map",
    :AudioList          => "audio_list_category.map",
    :FirstKnownList     => "first_known.map",

    :ImageList          => "recommend_detailed.recommend_record.recommend.map",
    :AudioListItem      => "audio_list.audio_list_category.map",
  }

  POLIABLE_NAME_OPTIONS = {
    :Video              => "videoable",
    :Audio              => "audioable",
    :Image              => "imageable",
    :Letter             => "textable"
  }

  OFFLINE_PKGS = [ 'Scenic', 'Place' ]
  PKG_PATH = 'public/uploads/packages'

  def after_save( model )
    update_map_version(model)
    create_offline_package(model)
  end

  def after_destroy( model )
    update_map_version(model)
  end

  private

  def update_map_version ( model )
    map_instance = get_map(model)
    return nil if map_instance.nil?

    RAILS_CACHE.write("map_#{map_instance.id}", map_instance.get_map_values)

    map_instance.version = Time.now.to_i
    map_instance.save
  end

  def update_keyword_version( model )
    model_slug = "%s_slug"%model.class.name.downcase
    keyword = model.send(model_slug)
    keyword.version = Time.now.to_i
    keyword.file_size = get_file_size_in_mega(keyword.slug)
    keyword.save
  end

  def get_file_size_in_mega( slug )
    fp = File.join(Rails.root.to_s, PKG_PATH, "%s.zip"%slug)
    fs = (File.size(fp).to_f / 2**20).round(2)
  end

  def create_offline_package( model )
    return unless OFFLINE_PKGS.include?(model.class.name)

    update_keyword_version(model)
    OfflinePackage.create_package model
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