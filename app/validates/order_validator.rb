class OrderValidator < ActiveModel::Validator

  NAV_PATH_OPTIONS = {
    # sub class              foreign key
    :Info                 => "info_list_id",
    :ChildrenBroadcast    => "broadcast_id",
    :AudioList            => "audio_list_category_id",
    :AudioListItem        => "audio_list_id",
  }

  def validate(record)
    klass = record.class.to_s
    fk = NAV_PATH_OPTIONS[ klass.to_sym ]

    all_orders = fk.nil? ? klass.constantize.all.map(&:order) :
                 klass.constantize.where(fk.to_sym => (record.send fk)).map(&:order)

    order_duplicate = all_orders.include?(record.order)

    if not record.new_record?
      old_order = klass.constantize.find(record.id).order
      all_orders.delete(old_order)
      is_invalid = old_order != record.order && all_orders.include?(record.order)
      ( record.errors.add :order, I18n.t("errors.type.duplicate_value"); return ) if is_invalid
    end

    state_ok = record.order.nil? || record.order.zero? || order_duplicate
    record.order = all_orders.empty? ? 1 : all_orders.max + 1 if state_ok
  end

end