class AddAudioTypeToAudios < ActiveRecord::Migration
  def change
    add_column :audios, :audio_type, :integer, :default => 0, :after => :duration
  end
end
