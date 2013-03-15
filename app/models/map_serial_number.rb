class MapSerialNumber < ActiveRecord::Base
  attr_accessible :map , :map_id, :code, :type, :count, :printed
  
  self.inheritance_column = ""
  
end
