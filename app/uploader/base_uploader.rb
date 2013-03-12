# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  
  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

  storage :file

  def store_dir
    "uploads"
  end
  
  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end
  
end
