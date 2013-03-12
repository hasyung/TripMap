# encoding: utf-8
require "base_uploader"

class ImageUploader  < BaseUploader
  
  version :thumbnail do
    process :resize_to_fit => [80, 80]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end
  
end
