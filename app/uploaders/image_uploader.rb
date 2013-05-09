# encoding: utf-8

require "base_uploader"

class ImageUploader  < BaseUploader

  version :thumbnail, :if => :is_share? do
    process :resize_to_fit => [480, 480]
  end

  protected 

  def is_share?(file)
    model.imageable_type == "Share"
  end

  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end

end