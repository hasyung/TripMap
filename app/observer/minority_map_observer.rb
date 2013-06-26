class MinorityMapObserver < ActiveRecord::Observer
  observe :minority_slide, :minority_feel

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

    RAILS_CACHE.write("map_#{map_instance.id}", map_instance.get_map_values)

    map_instance.version = Time.now.to_i
    map_instance.save
  end

  def get_map( model )
    map = nil
    poliable = model.minority
    ploy_type, ploy_type_id = "minorityable_type", "minorityable_id"
    ploy_object = poliable.send(ploy_type).constantize.find poliable.send(ploy_type_id)

    map = ploy_object.map if ploy_object.class.to_s == "Special"
    map
  end

end