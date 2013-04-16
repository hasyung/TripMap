class Info < ActiveRecord::Base

  # White list
  attr_accessible :info_list_id, :name, :slug, :order, :letter_attributes

  has_one :letter,  :as => :textable,   :dependent => :destroy

  belongs_to :info_list, :counter_cache => true

  # NestedAttributes
  accepts_nested_attributes_for :letter, reject_if: lambda { |pd| pd[:body].blank? }, :allow_destroy => true

  # Validates
  with_options :presence=> true do |column|
    column.validates :info_list_id
    column.validates :name, :length => { :within => 1..20,   :message => I18n.t("errors.type.name") }
    column.validates :slug, :length => { :within => 1..20 }, :format => { :with => /([a-z])+/, :message => I18n.t("errors.type.slug") }
  end

  validates :order, uniqueness: { scope: [:info_list_id, :order] },
                    numericality: { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 999 }

  # Scopes
  scope :order_asc,     order("`order` ASC")
  scope :created_desc,  order("created_at DESC")

end