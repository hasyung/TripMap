class AddInfoToLogs < ActiveRecord::Migration
  def change
  	add_column :logs, :info, :string, :after => :message_cd
  end
end
