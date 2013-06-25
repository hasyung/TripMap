module Admin::ApplicationHelper

  def is_storage?(picture)
    if !picture.place_id.zero?
      raw("<i class=\"icon-ok icon-white\"></i>")
    else
      raw("<i class=\"icon-remove icon-white\"></i>")
    end
  end

  def translate_format(source, t_prefix = nil)
    if !t_prefix.nil?
      t("#{t_prefix}.#{source.gsub(/[\s-]/, "_").downcase}")
    else
      t("#{source.gsub(/[\s-]/, "_").downcase}")
    end
  end

  def is_active(action_name, type)
    button_status = action_name == type ? "btn active" : "btn"
  end

  def get_edit_image_path(model, image_id)
    case model.class.name
    when "Map"
      path = edit_admin_map_image_path(model.id, image_id)
    when "Place"
      path = edit_admin_place_image_path(model.id, image_id)
    when "Scenic"
      path = edit_admin_scenic_image_path(model.id, image_id)
    when "Merchant"
      path = edit_admin_merchant_image_path(model.id, image_id)
    when "MinorityFeel"
      path = edit_admin_minority_feel_image_path(model.id, image_id)
    when "FirstKnown"
      path = edit_admin_first_known_image_path(model.id, image_id)
    when "Recommend"
      path = edit_admin_recommend_image_path(model.id, image_id)
    end

    path
  end

  def get_delete_image_path(model, image_id)
    case model.class.name
    when "Map"
      path = admin_map_image_path(model.id, image_id)
    when "Place"
      path = admin_place_image_path(model.id, image_id)
    when "Scenic"
      path = admin_scenic_image_path(model.id, image_id)
    when "Merchant"
      path = admin_merchant_image_path(model.id, image_id)
    when "MinorityFeel"
      path = admin_minority_feel_image_path(model.id, image_id)
    when "FirstKnown"
      path = admin_first_known_image_path(model.id, image_id)
    when "Recommend"
      path = admin_recommend_image_path(model.id, image_id)
    end

    path
  end
  
  def get_edit_polymorphic_path(model, id)
    case model.class.name
    when "Special"
      path = edit_admin_special_minority_path(model, id)
    when "Fight"
      path = edit_admin_fight_minority_path(model, id)
    end
    path
  end
  
  def get_delete_polymorphic_path(model, id)
    case model.class.name
    when "Special"
      path = admin_special_minority_path(model, id)
    when "Fight"
      path = admin_fight_minority_path(model, id)
    end
    path
  end
  
  def get_minority_form_url(model, parent)
    case parent.class.name
    when "Special"
      path = model.new_record? ? admin_special_minorities_path(parent) : admin_special_minority_path(parent, model)
    when "Fight"
      path = model.new_record? ? admin_fight_minorities_path(parent) : admin_fight_minority_path(parent, model)
    end
    path
  end
  
  def get_minority_feel_form_url(model, id, parent)
    case parent.class.name
    when "Special"
      path = model.new_record? ? admin_special_minority_feels_path(parent, id) : admin_special_minority_feel_path(parent, id, model)
    when "Fight"
      path = model.new_record? ? admin_fight_minority_feels_path(parent, id) : admin_fight_minority_feel_path(parent, id, model)
    end
    path
  end
  
  def get_minority_slide_form_url(model, id, parent)
    case parent.class.name
    when "Special"
      path = model.new_record? ? admin_special_minority_slides_path(parent, id) : admin_special_minority_slide_path(parent, id, model)
    when "Fight"
      path = model.new_record? ? admin_fight_minority_slides_path(parent, id) : admin_fight_minority_slide_path(parent, id, model)
    end
    path
  end

end