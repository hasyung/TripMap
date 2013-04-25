class InfoList < ActiveRecord::Base
  include ActiveModel::Validations

  # White list
  attr_accessible :map_id, :name, :slug, :order, :is_free

  # Associations
  has_many :infos, :dependent => :destroy

  belongs_to :map, :counter_cache => true

  # Validates
  with_options :presence => true do |column|
    column.validates :map_id
    column.validates :name, uniqueness: true, length: { within: 1..20 , message: I18n.t("errors.type.name") }
    column.validates :slug, uniqueness: true,
                            length: { within: 1..20 ,   message: I18n.t("errors.type.name") },
                            format: { with: /^[a-z]+$/, message: I18n.t("errors.type.slug") }
  end

  validates :order, numericality: { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }
  validates_with OrderValidator

  # Scopes
  scope :order_asc,     order("`order` ASC")
  scope :created_desc,  order("created_at DESC")

end