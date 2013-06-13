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
    end
    path
  end

end