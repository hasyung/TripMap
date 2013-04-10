class AddUniquesForAtomModels < ActiveRecord::Migration

  def change

    add_index :videos, [:videoable_id, :videoable_type, :order, :video_type], unique: true, :name => 'vvov_index'
    add_index :audios, [:audioable_id, :audioable_type, :order, :audio_type], unique: true, :name => 'aaoa_index'
    add_index :images, [:imageable_id, :imageable_type, :order, :image_type], unique: true, :name => 'iioi_index'
    add_index :texts,  [:textable_id,  :textable_type,  :order, :text_type],  unique: true, :name => 'ttot_index'
  end

end