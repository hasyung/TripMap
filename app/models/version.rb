require 'app/common'

class Version < ActiveRecord::Base
  include App::Common

  # White list
  attr_accessible :app, :description, :platform, :value, :url

  # Associations
  # To do

  # Validates
  with_options :presence => true do |column|
    column.validates :platform
    column.validates :description
    column.validates :value, uniqueness: { scope: [:platform, :value] }
  end

  # Carrierwave
  mount_uploader :app, CarrierWave::Uploader::Base do
    def store_dir
      dst = "uploads/app/"
      case model.platform
      when PLATFORM[:iOS]     then dst += "iOS"
      when PLATFORM[:Android] then dst += "Android"
      end
      dst
    end

    def extension_white_list; %w(ipa apk); end
  end

end