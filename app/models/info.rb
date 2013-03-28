class Info < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :map_id, :name, :slug, :order, :letter_attributes

  has_one :letter,  :as => :textable,   :dependent => :destroy

  belongs_to :map, :counter_cache => true
  
  # NestedAttributes
  accepts_nested_attributes_for :letter, reject_if: lambda { |pd| pd[:body].blank? }, :allow_destroy => true

   # Validates
  with_options :presence=> true do |column|
    column.validates :map_id
    column.validates :name, :length => { :within => 1..20,   :message => I18n.t("errors.type.name") }
    column.validates :slug, :length => { :within => 1..20 }, :format => { :with => /([a-z])+/, :message => I18n.t("errors.type.slug") }
  end
  validates_numericality_of :order, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999, :if => :order?
  validates :order, uniqueness: { scope: :map_id }
   # Scopes
  scope :order_asc, order("`order` ASC")
  scope :created_desc, order("created_at DESC")

end
