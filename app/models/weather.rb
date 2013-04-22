class Weather < ActiveRecord::Base

  # White list
  attr_accessible :map_id, :tmp_current, :tmp_desc, :tmp_humidity, :tmp_pic_from, :tmp_pic_to, :tmp_today, :tmp_wind

end