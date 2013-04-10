class Declaration < ActiveRecord::Base
  attr_accessible :body

  # Validates
  validates :body, :presence => true
  with_options :if => :body? do |body|
    body.validates :body, :length => { :within => 2..5000 }
  end
end
