class MapSerialNumber < ActiveRecord::Base

  # Disable type
  self.inheritance_column = ""

  # White list
  attr_accessible :map , :map_id, :code, :type_cd, :count, :activate_cd

  # Associations
  belongs_to :account
  belongs_to :map

  has_and_belongs_to_many :devices

  validates :code, :length => {:is => 16}, :format => { :with => /([0-9])+/}

  # Enumerators, simple_enum plugin
  as_enum :type, { :free => 0, :ordinary => 1, :favorite => 2 }
  as_enum :activate, { :no_activate => 0, :yes_activate => 1 }

  # Scopes
  scope :created_desc, order("created_at DESC")

  # Methods
  def self.to_csv( options = {} )
    CSV.generate(options) do |csv|
      csv << column_names
      all.each{|serial| csv << serial.attributes.values_at(*column_names) }
    end
  end

end