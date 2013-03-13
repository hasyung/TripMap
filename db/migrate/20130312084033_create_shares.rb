class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
    	t.references  :map,	    :null => false
    	t.string      :ip,      :limit => 15
    	t.string	    :title,		:null => false, :limit => 20
    	t.integer     :state,	  :default => 0
      t.timestamps
    end
  end
end
