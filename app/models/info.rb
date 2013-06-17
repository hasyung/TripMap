class Info < ActiveRecord::Base
  include ActiveModel::Validations

  # White list
  attr_accessible :info_list_id, :name, :slug, :order, :is_free,
                  :letter_attributes, :info_slug_attributes

  # Associations
  belongs_to :info_list, :counter_cache => true

  has_one :letter, :as => :textable, :dependent => :destroy

  with_options :as => :keywordable, :class_name => 'Keyword', :dependent => :destroy do|assoc|
    assoc.has_one :info_slug, :conditions => { :keyword_type => Keyword.info_slug }
  end

  # Validates
  with_options :presence=> true do |column|
    column.validates :info_list_id
    column.validates :name, uniqueness: true, length: { within: 1..20 }
  end

  validates :order, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  validates_with OrderValidator

  # Nested attributes validates
  accepts_nested_attributes_for :letter, reject_if: ->(attr){ attr[:body].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :info_slug,                                         :allow_destroy => true

  # Scopes
  scope :order_asc,    order("`order` ASC")
  scope :created_desc, order("created_at DESC")

end