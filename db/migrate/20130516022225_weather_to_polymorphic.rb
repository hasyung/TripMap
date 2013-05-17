class WeatherToPolymorphic < ActiveRecord::Migration

  def change
    change_table(:weathers) do |t|
     t.remove :map_id
     t.references        :weatherable,     :polymorphic => true,   :after => :id
    end

    add_index :weathers, [:weatherable_type, :weatherable_id], unique: true
  end

end