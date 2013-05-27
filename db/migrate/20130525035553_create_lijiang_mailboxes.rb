class CreateLijiangMailboxes < ActiveRecord::Migration

  def change
    create_table :lijiang_mailboxes do |t|
      t.string  :device_id,                  :null => false
      t.integer :service_score,              :default => 0
      t.integer :env_score,                  :default => 0
      t.integer :category,                   :default => 0
      t.string  :title,                      :null => true
      t.string  :content,                    :null => true
      t.string  :who,                        :null => true
      t.string  :contact,                    :null => true

      t.timestamps
    end
  end

end