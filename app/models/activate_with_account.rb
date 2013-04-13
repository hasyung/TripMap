class ActivateWithAccount < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :account
  belongs_to :activate_map
end
