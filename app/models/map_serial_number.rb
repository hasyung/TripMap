class MapSerialNumber < ActiveRecord::Base

  # Disable type
  self.inheritance_column = ""

  # White list
  attr_accessible :map , :map_id, :code, :type_cd, :count, :printed_cd

  # Associations
  has_many :activate_maps, :dependent => :destroy
  has_one :nickname, :dependent => :destroy
  belongs_to :map

  # Enumerators, simple_enum plugin
  as_enum :type, { :free => 0, :ordinary => 1, :favorite => 2 }
  as_enum :printed, { :no_print => 0, :yes_print => 1 }

  # Scopes
  scope :created_desc, order("created_at DESC")

  # Methods
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |serial|
        csv << serial.attributes.values_at(*column_names)
      end
    end
  end

end