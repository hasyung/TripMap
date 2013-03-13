class Province < ActiveRecord::Base
  
  # White list
  attr_accessible :name, :slug
  
  # Associations
  has_many :maps, :dependent => :destroy
  
  # Validates
  with_options :presence => true do |column|
    column.validates :name, :length => { :within => 2..15,    :message => I18n.t("errors.type.name") }
    column.validates :slug, :format => { :with => /([a-z])+/, :message => I18n.t("errors.type.slug") }
  end
  
end