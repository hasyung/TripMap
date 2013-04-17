class InfoList < ActiveRecord::Base

  # White list
  attr_accessible :map_id, :name, :slug, :order

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

  validates :order, uniqueness: { scope: [:map_id, :order] },
                    format:     { with: /^[1-9][0-9]{0,2}$/, message: I18n.t("errors.type.order") }

  # Scopes
  scope :order_asc,     order("`order` ASC")
  scope :created_desc,  order("created_at DESC")

end