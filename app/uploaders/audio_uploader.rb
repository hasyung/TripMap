# encoding: utf-8

require "base_uploader"

class AudioUploader < BaseUploader

  def store_dir
    "uploads/audios"
  end

  def extension_white_list
    %w(mp3 wmv)
  end
  
end
