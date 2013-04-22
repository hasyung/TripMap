class CreateWeathers < ActiveRecord::Migration

  def change

    create_table :weathers do |t|
      t.references  :map,               :null => false

      t.string :tmp_current
      t.string :tmp_today
      t.string :tmp_desc
      t.string :tmp_wind
      t.string :tmp_pic_from
      t.string :tmp_pic_to
      t.string :tmp_humidity

      t.timestamps
    end

  end

end