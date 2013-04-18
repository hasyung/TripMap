class OrderValidator < ActiveModel::Validator

  def validate(record)
    klass = record.class.to_s
    all_orders = klass.constantize.all.map(&:order)
    order_duplicate = all_orders.include?(record.order)

    if not record.new_record?
      old_order = klass.constantize.find(record.id).order
      all_orders.delete(old_order)
      is_invalid = old_order != record.order && all_orders.include?(record.order)
      (record.errors.add :order, I18n.t("errors.type.duplicate_value"); return ) if is_invalid
    end

    record.order = all_orders.max + 1 if record.order.nil? or record.order.zero? or order_duplicate
  end

end