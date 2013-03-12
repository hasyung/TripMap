# encoding: utf-8
require 'base_uploader'

class VideoUploader < BaseUploader

  def store_dir
    "uploads/videos"
  end

  def extension_white_list
    %w(mp4 m4v)
  end
  
end
