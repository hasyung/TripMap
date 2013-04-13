class MapSerialNumber < ActiveRecord::Base

  # Disable type
  self.inheritance_column = ""

  # White list
  attr_accessible :map , :map_id, :code, :type_cd, :count, :activate_cd

  # Associations
  belongs_to :account
  belongs_to :map

  # Enumerators, simple_enum plugin
  as_enum :type, { :free => 0, :ordinary => 1, :favorite => 2 }
  as_enum :activate, { :no_activate => 0, :yes_activate => 1 }

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