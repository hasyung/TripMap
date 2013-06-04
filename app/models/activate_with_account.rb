class ActivateWithAccount < ActiveRecord::Base

  # Associations
  belongs_to :account
  belongs_to :activate_map

end