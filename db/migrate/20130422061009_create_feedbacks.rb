class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :account
      t.string :body, null: false, limit: 1000
      t.timestamps
    end
  end
end
