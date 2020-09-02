class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :product_id
      t.string :content
      t.timestamps
    end
    add_index("comments", ["product_id", "user_id"])
  end
end
