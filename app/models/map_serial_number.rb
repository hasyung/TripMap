class MapSerialNumber < ActiveRecord::Base
  attr_accessible :map , :map_id, :code, :type_cd, :count, :printed_cd
  
  self.inheritance_column = ""

  belongs_to :map

  as_enum :type, { :free => 0, :ordinary => 1, :favorite => 2 }
  as_enum :printed, { :no_print => 0, :yes_print => 1 }

  scope :created_desc, order("created_at DESC")

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |serial|
        csv << serial.attributes.values_at(*column_names)
      end
    end
  end
  
end
