class Log < ActiveRecord::Base
	attr_accessible :map_id, :activate_map_id, :device_type_cd, :slug, :message_cd

	belongs_to :map
	belongs_to :activate_map

	#SimpleEnum
	as_enum :device_type, { :iPhone => 0, :android => 1 }
	as_enum :message, { :success => 0, :time_out => 1, :not_found => 2, :error => 3 }

	# Scopes
	scope :created_desc, order("created_at DESC")

  # Validates
	with_options :presence=> true do |column|
	  column.validates :map_id
	  column.validates :activate_map_id
	  column.validates :slug, :format => { :with => /([a-z])+/ }, :length => { :within => 1..20 }, :uniqueness => true
	end
end
