class Download < ActiveRecord::Base
  self.inheritance_column = nil

  # White list
  attr_accessible :count, :type

  # Scope
  scope :get_downloads, ->(type){ where(:type => type) }

end