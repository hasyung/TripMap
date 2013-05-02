class CreateDownloads < ActiveRecord::Migration

  def change
    create_table :downloads do |t|
      t.integer :count

      t.timestamps
    end
  end

end