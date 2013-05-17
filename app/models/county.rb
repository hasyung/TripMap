class County < ActiveRecord::Base
  # White list
  attr_accessible :name, :slug, :city, :city_id

  # Associations
  has_many :merchants, :autosave => true
  belongs_to :city, :counter_cache => true

  # Validates
  with_options :presence => true do |column|
    column.validates :city_id
    column.validates :name, :length => { :within => 2..20 }, :uniqueness => true
    column.validates :slug, :length => { :within => 2..20 },  :format => { :with => /^[a-z]+$/, :message => I18n.t("errors.type.slug") }, :uniqueness => true
  end

  scope :created_desc, order("`created_at` DESC")
end
