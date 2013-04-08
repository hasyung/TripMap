# encoding: utf-8

require 'base_uploader'

class VideoUploader < BaseUploader

  def extension_white_list
    %w(mp4 m4v)
  end

end