class CreateDeclarations < ActiveRecord::Migration
  def change
    create_table :declarations do |t|
      t.text :body, null: false
      t.timestamps
    end
  end
end
