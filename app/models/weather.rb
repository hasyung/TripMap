class Weather < ActiveRecord::Base

  # White list
  attr_accessible :weatherable_type, :weatherable_id, :tmp_current, :tmp_desc, :tmp_humidity, :tmp_pic_from, :tmp_pic_to, :tmp_today, :tmp_wind

  # Associations
  belongs_to :weatherable, :polymorphic => true

  # Validates
  with_options :presence => true do |column|
    column.validates :weatherable_type
    column.validates :weatherable_id
  end

end