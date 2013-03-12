# encoding: utf-8
require "base_uploader"

class ImageUploader  < BaseUploader
  
  version :thumbnail, :if => :is_share? do
    process :resize_to_fit => [80, 80]
  end
  
  def store_dir
    "uploads/images"
  end
  
  protected
  
  def is_share?
    model.class_name == "Share"
  end
  
  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end
  
end
