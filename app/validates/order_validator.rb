class OrderValidator < ActiveModel::Validator

  NAV_PATH = {
    # Model class         Foreign key(belongs_to_##id##)
    :Info                 => "info_list_id",
    :ChildrenBroadcast    => "broadcast_id",
    :AudioList            => "audio_list_category_id",
    :AudioListItem        => "audio_list_id",
    :FirstKnownList       => "first_known_id",
    :ImageList            => "recommend_detailed_id",
    :MinorityFeel         => "minority_id",
    :MinoritySlide        => "minority_id",
    :Minority             => "special_id",
    :RecommendDetailed    => "recommend_record_id",
    :RecommendRecord      => "recommend_id",
    :FirstKnownListItem   => "first_known_list_id",
  }

  ATOM = {
    # Poly class          Combination keys
    :Letter               => ['text_type', 'textable_id', 'textable_type'],
    :Audio                => ['audio_type', 'audioable_id', 'audioable_type'],
    :Video                => ['video_type', 'videoable_id', 'videoable_type'],
    :Image                => ['image_type', 'imageable_id', 'imageable_type'],
  }

  def validate(record)
    klass = record.class.to_s
    fk = NAV_PATH[ klass.to_sym ]
    ck = ATOM[ klass.to_sym ]

    all_orders = []
    if ck.nil?
      all_orders = fk.nil? ? klass.constantize.all.map(&:order) :
                   klass.constantize.where(fk.to_sym => (record.send fk)).map(&:order)
    else
      conditions = {}
      ck.each{|attr| conditions[attr] = (record.send attr) }
      all_orders = klass.constantize.where(conditions).map(&:order)
    end

    order_duplicate = all_orders.include?(record.order)

    unless record.new_record?
      old_order = klass.constantize.find(record.id).order
      all_orders.delete(old_order)
      is_invalid = old_order != record.order && all_orders.include?(record.order)
      ( record.errors.add :order, I18n.t("errors.type.duplicate_value"); return ) if is_invalid
      return
    end

    state_ok = record.order.nil? || record.order.zero? || order_duplicate
    record.order = all_orders.empty? ? 1 : all_orders.max + 1 if state_ok
  end

end