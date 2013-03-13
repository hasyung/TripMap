# encoding: utf-8

require "base_uploader"

class AudioUploader < BaseUploader
  
  def extension_white_list
    %w(mp3 wmv)
  end
  
end
